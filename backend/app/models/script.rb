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
    [:id, :name, :description, :code, :active, :created_at]
  end

  def self.all
    sql = "SELECT
  #{Script.columns.map{|c|"s.`#{c}` as s_#{c}"}.join(",")},
  #{Trigger.columns.map{|c|"t.`#{c}` as t_#{c}"}.join(",")},
  max(sr.run_at) as s_last_run
FROM scripts s
  LEFT JOIN triggers t on s.id=t.script_id
  LEFT JOIN script_runs sr on s.id=sr.script_id
GROUP BY s.id, t.id"
    DataMapper.select(sql, {
      prefix: 's',
      has_many: [
        { triggers: { prefix: 't' } }
      ]
    })
  end

  def self.for_queue(name)
    sql = "SELECT
  #{Script.columns.map{|c|"s.`#{c}` as s_#{c}"}.join(",")},
  #{Trigger.columns.map{|c|"t.`#{c}` as t_#{c}"}.join(",")}
FROM scripts s
  LEFT JOIN triggers t on s.id=t.script_id
WHERE t.queue_name = ?"
    DataMapper.select(sql, {
      prefix: 's',
      has_many: [
        { triggers: { prefix: 't'  } }
      ]
    }, name)
  end

  def self.find(id)
    sql = "SELECT
  #{Script.columns.map{|c|"s.`#{c}` as s_#{c}"}.join(",")},
  #{Trigger.columns.map{|c|"t.`#{c}` as t_#{c}"}.join(",")}
FROM scripts s
  LEFT JOIN triggers t on s.id=t.script_id
WHERE s.id = ?
    "
    DataMapper.select(sql, {
      prefix: 's',
      has_many: [
        { triggers: { prefix: 't' } }
      ]
    }, id).first
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
      id:          script[:id],
      name:        script[:name],
      description: script[:description],
      code:        script[:code],
      active:      script[:active],
      created_at:  Time.new(script[:created_at])
    }
  end

  def self.trigger_to_fields(trigger)
    return {
      id:         trigger[:id],
      script_id:  trigger[:script_id],
      type:       trigger[:type],
      active:     trigger[:active],
      every:      trigger[:every],
      queue_name: trigger[:queue_name],
      created_at: Time.new(trigger[:created_at])
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

  def self.run_code(code, input = nil, script_id=nil, trigger_id=nil, queue_name=nil, queue_item_key=nil)
    executor = SimpleLanguage::Executor.new
    q = DataQueue.new
    executor.register("queue", q, :queue)
    executor.register("store", q, :store)
    executor.register("has_key?", q, :has_key?)
    executor.register("retrieve", q, :retrieve)
    executor.register("save", q, :save)
    executor.register("log", q, :log)
    output = nil
    error = nil
    begin
      output = executor.run(code, input)
    rescue SimpleLanguage::NullPointer => e
      error = "#{e.class.to_s} #{e.to_s}"
    end
    script_run = {
      id: SecureRandom.uuid,
      script_id: script_id,
      trigger_id: trigger_id,
      queue_name: queue_name,
      queue_item_key: queue_item_key,
      code: code,
      output: output,
      error: error,
      run_at: Time.now
    }
    DataMapper.insert("script_runs", script_run)
    return script_run
  end

end
