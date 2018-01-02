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

  @@traces = {}

  def self.columns
    [:id, :name, :category, :description, :default_input, :code, :trigger_cron, :cron_every, :cron_last_run, :cron_locked_at, :trigger_queue, :queue_name, :trigger_http, :http_method, :http_endpoint, :http_request_content_type, :http_response_content_type, :created_at]
  end

  def self.all
    sql = "SELECT
  #{Script.columns.map{|c|"s.`#{c}` as s_#{c}"}.join(",")},
  max(sr.run_at) as s_last_run
FROM scripts s
  LEFT JOIN script_runs sr on s.id=sr.script_id
GROUP BY s.id
ORDER BY s.`name`"
    rows = DataMapper.select(sql, {
      prefix: 's',
      has_many: [
      ]
    })
    rows
  end

  def self.for_queue(name)
    sql = "SELECT
  #{Script.columns.map{|c|"s.`#{c}` as s_#{c}"}.join(",")}
FROM scripts s
WHERE s.queue_name = ?"
    rows = DataMapper.select(sql, {
      prefix: 's',
      has_many: [
      ]
    }, name)
    return nil if rows.length == 0
    rows.first
  end

  def self.next_cron_script
    script_ids = Script.overdue_cron_script_ids
    script_ids.each do |script_id|
      locked = Script.lock_cron_script(script_id)
      next if !locked
      return Script.find(script_id)
    end
    return nil
  end

  def self.mark_cron_as_run(script_id)
    sql = "UPDATE scripts SET cron_last_run=NOW(), cron_locked_at=NULL WHERE id=? AND cron_locked_at IS NOT NULL"
    stmt = nil
    results = nil
    DB.use do |db|
      stmt = db.prepare(sql)
      results = stmt.execute(script_id)
      return db.affected_rows
    end
  end

  def self.overdue_cron_script_ids
    sql = "
SELECT
  s.id
FROM scripts s
WHERE
  s.trigger_cron = TRUE AND
  s.cron_locked_at IS NULL AND
  (s.cron_last_run IS NULL OR
   (s.cron_last_run + INTERVAL s.cron_every MINUTE) < NOW())
ORDER BY s.cron_last_run
"
    rows = DataMapper.raw_select(sql)
    rows.map{|r|r[:id]}
  end

  def self.lock_cron_script(script_id)
    sql = "UPDATE scripts SET cron_locked_at=NOW() WHERE id=? AND cron_locked_at IS NULL"
    stmt = nil
    results = nil
    DB.use do |db|
      stmt = db.prepare(sql)
      results = stmt.execute(script_id)
      return db.affected_rows
    end
  end

  def self.find(id)
    sql = "SELECT
  #{Script.columns.map{|c|"s.`#{c}` as s_#{c}"}.join(",")}
FROM scripts s
WHERE s.id = ?
    "
    row = DataMapper.select(sql, {
      prefix: 's',
      has_many: [
      ]
    }, id).first
    return nil if !row
    row
  end

  def self.find_by_http_endpoint(endpoint, method)
    sql = "SELECT
  #{Script.columns.map{|c|"s.`#{c}` as s_#{c}"}.join(",")}
FROM scripts s
WHERE s.active=true AND s.http_endpoint = ? AND s.http_method = ?"
    row = DataMapper.select(sql, {
      prefix: 's',
      has_many: [
      ]
    }, [endpoint, method]).first
    return nil if !row
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
      id:                         script[:id],
      name:                       script[:name],
      category:                   script[:category],
      description:                script[:description],
      default_input:              script[:default_input],
      code:                       script[:code],
      trigger_cron:               script[:trigger_cron],
      cron_every:                 script[:cron_every],
      cron_last_run:              script[:cron_last_run]?Time.new(script[:cron_last_run]):nil,
      cron_locked_at:             script[:cron_locked_at]?Time.new(script[:cron_locked_at]):nil,
      trigger_queue:              script[:trigger_queue],
      queue_name:                 script[:queue_name],
      trigger_http:               script[:trigger_http],
      http_method:                script[:http_method],
      http_endpoint:              script[:http_endpoint],
      http_request_content_type:  script[:http_request_content_type],
      http_response_content_type: script[:http_response_content_type],
      created_at:                 script[:created_at]?Time.new(script[:created_at]):nil
    }
  end

  def self.update(script)
    fields = script_to_fields script
    DataMapper.update('scripts', fields)
    return script
  end

  def self.insert(script)
    script[:id] = SecureRandom.uuid unless script[:id]
    script[:created_at] = Time.now.to_s unless script[:created_at]
    fields = script_to_fields script
    DataMapper.insert('scripts', fields)
    return script
  end

  def self.set_default_input(script_id, payload)
    fields = {
      id: script_id,
      default_input: payload,
    }
    DataMapper.update('scripts', fields)
  end

  def self.get_traces(trace_id)
    return nil if !trace_id
    @@traces[trace_id.to_i]
  end

  def self.run_code(code, input = nil, trace_id = nil, script_id=nil)
    trace = []
    if trace_id
      @@traces[trace_id] = []
      trace = @@traces[trace_id]
    end
    executor = SimpleLanguage::Executor.new
    Extension.all.keys.each do |class_string|
      clazz = Object.const_get("SimpleLanguage::#{class_string}")
      o = clazz.new(trace)
      #methods = clazz.instance_methods - Object.instance_methods
      #methods.each do |method|
      #  executor.register(method.to_s, o, method)
      #end
      class_alias = class_string.gsub(/::/, '/').gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').tr("-", "_").downcase
      executor.register_external_value(class_alias, o)
    end
    output = nil
    error = nil
    begin
      output = executor.run(code, input, trace)
    #rescue SimpleLanguage::NullPointer => e
    # catch all execptions like this for now
    rescue Exception => e
      #raise e
      error = "#{e.class.to_s} #{e.to_s}"
    end
    script_run = {
      script_id: script_id,
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
