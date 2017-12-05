require './app/database/database.rb'

# manages script runs in database
class ScriptRun

  def self.last_n(script_id, n)
    sql = "
SELECT
  sr.id as sr_id, sr.code as sr_code, sr.output as sr_output, sr.error as sr_error, sr.run_at as sr_run_at,
  t.id as t_id, t.name as t_name, ct.every as t_every, qt.queue_name as t_queue_name
FROM script_runs sr
  LEFT JOIN triggers t on sr.trigger_id=t.script_id
  LEFT JOIN cron_triggers ct on t.info_type='cron' AND t.info_id=ct.id
  LEFT JOIN queue_triggers qt on t.info_type='queue' AND t.info_id=qt.id
WHERE sr.script_id = ?
LIMIT ?
    "
    DataMapper.select(sql, {
      prefix: 'sr',
      has_many: [
        { triggers: { prefix: 't' } }
      ]
    }, [script_id, n])
  end

end
