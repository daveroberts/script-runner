require './app/database/database.rb'

# manages cron triggers in database
class CronTrigger
  def self.all
    sql = "
SELECT
  t.id as trigger_id,
  t.name as trigger_name,
  ct.every as cron_trigger_every,
  s.id as script_id,
  s.name as script_name,
  s.description as script_description,
  s.script as script_script,
  max(sr.run_at) as last_run
FROM cron_triggers ct
  LEFT JOIN triggers t ON ct.id=t.info_id AND t.info_type='cron'
  LEFT JOIN scripts s on t.script_id=s.id
  LEFT JOIN script_runs sr on t.id=sr.trigger_id
WHERE
  t.active = true AND s.active = true
GROUP BY t.id"
    stmt = nil
    results = nil
    triggers = []
    DB.use do |db|
      stmt = db.prepare(sql)
      results = stmt.execute()
      results.each do |row|
        trigger = {
          id: row[:trigger_id],
          trigger_name: row[:trigger_name],
          every: row[:cron_trigger_every],
          script_id: row[:script_id],
          script_name: row[:script_name],
          description: row[:script_description],
          script: row[:script_script],
          last_run: row[:last_run]
        }
        triggers.push(trigger)
      end
    end
    return triggers
  end
end
