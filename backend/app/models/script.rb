require 'securerandom'
require './lib/simple-language-parser/executor.rb'

# manages scripts in database
class Script

  def self.all
    sql = "
SELECT
  s.id as s_id, s.name as s_name, s.description as s_description, s.code as s_code, s.active as s_active, s.created_at as s_created_at,
  t.id as t_id, t.type as t_type, t.every as t_every, t.queue_name as t_queue_name
FROM scripts s
  LEFT JOIN triggers t on s.id=t.script_id
    "
    DataMapper.select(sql, {
      prefix: 's',
      has_many: [
        { triggers: { prefix: 't' } }
      ]
    })
  end

  def self.for_queue(name)
    sql = "
SELECT
  s.id as s_id, s.name as s_name, s.description as s_description, s.code as s_code, s.active as s_active, s.created_at as s_created_at,
  t.id as t_id, t.type as t_type, t.queue_name as t_queue_name
FROM scripts s
  LEFT JOIN script_runs sr on s.id=sr.script_id
  LEFT JOIN triggers t on s.id=t.script_id
WHERE
  qt.queue_name = ?
    "
    DataMapper.select(sql, {
      prefix: 's',
      has_many: [
        { triggers: { prefix: 't'  } }
      ]
    }, name)
  end

  def self.find(id)
    sql = "
SELECT
  s.id as s_id, s.name as s_name, s.description as s_description, s.code as s_code, s.active as s_active, s.created_at as s_created_at,
  t.id as t_id, t.type as t_type, t.every as t_every, t.queue_name as t_queue_name
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

  def self.run_code(code, arg = nil, script_id=nil, trigger_id=nil)
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
      output = executor.run(code, arg)
    rescue SimpleLanguage::NullPointer => e
      error = "#{e.class.to_s} #{e.to_s}"
    end
    script_run = {
      id: SecureRandom.uuid,
      script_id: script_id,
      trigger_id: trigger_id,
      code: code,
      output: output,
      error: error,
      run_at: Time.now
    }
    DataMapper.insert("script_runs", script_run)
    return output
  end

end
