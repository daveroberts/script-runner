require './app/database/database.rb'
require 'securerandom'

# manages scripts in database
class Script

  def self.all
    sql = "
SELECT
  s.id as s_id,
  s.name as s_name,
  s.code as s_code,
  sr.id as sr_id,
  sr.code as sr_code,
  sr.run_at as sr_time_run,
  t.id as t_id,
  t.name as t_name,
  ct.every as t_every,
  qt.queue_name as t_queue_name
FROM scripts s
  LEFT JOIN script_runs sr on s.id=sr.script_id
  LEFT JOIN triggers t on s.id=t.script_id
  LEFT JOIN cron_triggers ct on t.info_type='cron' AND t.info_id=ct.id
  LEFT JOIN queue_triggers qt on t.info_type='queue' AND t.info_id=qt.id
    "
    DataMapper.select(sql, {
      prefix: 's',
      has_many: [
        { script_runs: { prefix: 'sr' } },
        { triggers:    { prefix: 't'  } }
      ]
    })
  end

  def self.run_ad_hoc(script, arg = nil)
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
      output = executor.run(script, arg)
    rescue SimpleLanguage::NullPointer => e
      error = "#{e.class.to_s} #{e.to_s}"
    end
    script_run = {
      id: SecureRandom.uuid,
      script_id: nil,
      trigger_id: nil,
      script: script,
      output: output,
      error: error,
      run_at: Time.now
    }
    DataMapper.insert("script_runs", script_run)
    return output
  end

  def self.pull_trigger(trigger_id, script_id, script, arg = nil)
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
      output = executor.run(script, arg)
    rescue SimpleLanguage::NullPointer => e
      error = "#{e.class.to_s} #{e.to_s}"
    end
    script_run = {
      id: SecureRandom.uuid,
      script_id: script_id,
      trigger_id: trigger_id,
      script: script,
      output: output,
      error: error,
      run_at: Time.now
    }
    DataMapper.insert("script_runs", script_run)
  end
end
