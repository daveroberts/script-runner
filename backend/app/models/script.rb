require 'securerandom'
require './lib/simple-language-parser/executor.rb'

class InvalidScript < StandardError
  attr_reader :error
  def initialize(error)
    @error = error
  end
end

# manages scripts in database
class Script

  def self.columns
    [:id, :name, :category, :description, :default_input, :default_input_mime_type, :extensions, :code, :active, :created_at]
  end

  def self.all
    sql = "SELECT
  #{Script.columns.map{|c|"s.`#{c}` as s_#{c}"}.join(",")},
  #{Trigger.columns.map{|c|"t.`#{c}` as t_#{c}"}.join(",")},
  max(sr.run_at) as s_last_run
FROM scripts s
  LEFT JOIN triggers t on s.id=t.script_id
  LEFT JOIN script_runs sr on s.id=sr.script_id
GROUP BY s.id, t.id
ORDER BY s.`name`"
    rows = DataMapper.select(sql, {
      prefix: 's',
      has_many: [
        { triggers: { prefix: 't' } }
      ]
    })
    rows.each do |r|
      r[:extensions] = r[:extensions]?JSON.parse(r[:extensions], symbolize_names: true):[]
    end
    rows
  end

  def self.for_queue(name)
    sql = "SELECT
  #{Script.columns.map{|c|"s.`#{c}` as s_#{c}"}.join(",")},
  #{Trigger.columns.map{|c|"t.`#{c}` as t_#{c}"}.join(",")}
FROM scripts s
  LEFT JOIN triggers t on s.id=t.script_id
WHERE t.queue_name = ?"
    rows = DataMapper.select(sql, {
      prefix: 's',
      has_many: [
        { triggers: { prefix: 't'  } }
      ]
    }, name)
    rows.each do |r|
      r[:extensions] = r[:extensions]?JSON.parse(r[:extensions], symbolize_names: true):[]
    end
    rows
  end

  def self.find(id)
    sql = "SELECT
  #{Script.columns.map{|c|"s.`#{c}` as s_#{c}"}.join(",")},
  #{Trigger.columns.map{|c|"t.`#{c}` as t_#{c}"}.join(",")}
FROM scripts s
  LEFT JOIN triggers t on s.id=t.script_id
WHERE s.id = ?
    "
    row = DataMapper.select(sql, {
      prefix: 's',
      has_many: [
        { triggers: { prefix: 't' } }
      ]
    }, id).first
    return nil if !row
    row[:extensions] = row[:extensions]?JSON.parse(row[:extensions], symbolize_names: true):[]
    row
  end

  def self.find_by_http_endpoint(endpoint, method)
    sql = "SELECT
  #{Script.columns.map{|c|"s.`#{c}` as s_#{c}"}.join(",")},
  #{Trigger.columns.map{|c|"t.`#{c}` as t_#{c}"}.join(",")}
FROM scripts s
  LEFT JOIN triggers t on s.id=t.script_id
WHERE t.type='HTTP' AND s.active=true AND t.active=true AND t.http_endpoint = ? AND t.http_method = ?"
    row = DataMapper.select(sql, {
      prefix: 's',
      has_many: [
        { triggers: { prefix: 't' } }
      ]
    }, [endpoint, method]).first
    return nil if !row
    row[:extensions] = row[:extensions]?JSON.parse(row[:extensions], symbolize_names: true):[]
    row
  end

  def self.save(script)
    validation_errors = self.validation_errors(script)
    raise InvalidScript, validation_errors if validation_errors
    self.update(script) if script[:id]
    self.insert(script) if !script[:id]
    return script
  end

  def self.validation_errors(script)
    field_errors = {}
    field_errors[:name] = "Name cannot be blank" if script[:name].blank?
    sql = "SELECT id from scripts WHERE id != ? AND name = ?"
    DB.use do |db|
      stmt = db.prepare(sql)
      results = stmt.execute(script[:id]||"", script[:name])
      field_errors[:name] = "Script name already taken" if results.count > 0
    end
    return {
      error_type: 'validation',
      message: 'Could not save the script.  There was a validation error.',
      field_errors: field_errors
    } if field_errors.any?
    return nil
  end

  def self.script_to_fields(script)
    return {
      id:                      script[:id],
      name:                    script[:name],
      category:                script[:category],
      description:             script[:description],
      default_input:           script[:default_input],
      default_input_mime_type: script[:default_input_mime_type],
      extensions:              script[:extensions].to_json,
      code:                    script[:code],
      active:                  script[:active],
      created_at:              Time.new(script[:created_at])
    }
  end

  def self.trigger_to_fields(trigger)
    return {
      id:             trigger[:id],
      script_id:      trigger[:script_id],
      type:           trigger[:type],
      active:         trigger[:active],
      every:          trigger[:every],
      queue_name:     trigger[:queue_name],
      http_endpoint:  trigger[:http_endpoint],
      http_method:    trigger[:http_method],
      created_at:     Time.new(trigger[:created_at])
    }
  end

  def self.update(script)
    fields = script_to_fields script
    DataMapper.update('scripts', fields)
    self.save_triggers(script)
    return script
  end

  def self.insert(script)
    script[:id] = SecureRandom.uuid unless script[:id]
    script[:created_at] = Time.now.to_s unless script[:created_at]
    fields = script_to_fields script
    DataMapper.insert('scripts', fields)
    self.save_triggers(script)
    return script
  end

  def self.save_triggers(script)
    script[:triggers].each do |trigger|
      trigger[:script_id] = script[:id]
      trigger[:created_at] = Time.now.to_s unless trigger[:created_at]
      if trigger[:id]
        fields = trigger_to_fields(trigger)
        DataMapper.update("triggers", fields)
      else
        trigger[:id] = SecureRandom.uuid unless trigger[:id]
        fields = trigger_to_fields(trigger)
        DataMapper.insert("triggers", fields)
      end
    end
    # delete doomed triggers
    sql = ''
    if script[:triggers].length > 0
      sql = "DELETE FROM triggers WHERE script_id=? and id NOT IN (#{script[:triggers].map{|t|"'#{t[:id]}'"}.join(',')})"
    else
      sql = "DELETE FROM triggers WHERE script_id=?"
    end
    DB.use do |db|
      stmt = db.prepare(sql)
      stmt.execute(script[:id])
    end
  end

  def self.set_default_input(script_id, payload, mime_type)
    fields = {
      id: script_id,
      default_input: payload,
      default_input_mime_type: mime_type
    }
    DataMapper.update('scripts', fields)
  end

  def self.run_code(code, input = nil, extensions = [], script_id=nil, trigger_id=nil, queue_name=nil, queue_item_key=nil)
    executor = SimpleLanguage::Executor.new
    extensions.each do |class_string|
      clazz = Object.const_get(class_string)
      o = clazz.new
      methods = clazz.instance_methods - Object.instance_methods
      methods.each do |method|
        executor.register(method.to_s, o, method)
      end
    end
    output = nil
    error = nil
    begin
      output = executor.run(code, input)
    #rescue SimpleLanguage::NullPointer => e
    # catch all execptions like this for now
    rescue Exception => e
      error = "#{e.class.to_s} #{e.to_s}"
    end
    script_run = {
      script_id: script_id,
      trigger_id: trigger_id,
      queue_name: queue_name,
      queue_item_key: queue_item_key,
      extensions: extensions,
      input: input,
      code: code,
      output: output,
      error: error,
      run_at: Time.now
    }
    ScriptRun.add(script_run)
    return script_run
  end

end
