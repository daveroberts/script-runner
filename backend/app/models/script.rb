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
    rows
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
      active:                     script[:active],
      cron_every:                 script[:cron_every],
      cron_last_run:              script[:cron_last_run],
      cron_locked_at:             script[:cron_locked_at],
      queue_name:                 script[:queue_name],
      http_endpoint:              script[:http_endpoint],
      http_method:                script[:http_method],
      http_request_accept:        script[:http_request_accept],
      http_response_content_type: script[:http_response_content_type],
      created_at:                 Time.new(script[:created_at])
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
    trace = nil
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
