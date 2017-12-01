require './app/database/database.rb'

# manages queue triggers in database
class QueueTrigger
  def self.all
    sql = "
SELECT
  t.id as trigger_id,
  t.name as trigger_name,
  qt.queue_name as queue_name,
  s.id as script_id,
  s.name as script_name,
  s.description as script_description,
  s.script as script_script,
  max(sr.run_at) as last_run
FROM queue_triggers qt
  LEFT JOIN triggers t ON qt.id=t.info_id AND t.info_type='queue'
  LEFT JOIN scripts s on t.script_id=s.id
  LEFT JOIN script_runs sr on t.id=sr.trigger_id
WHERE
  t.active = true AND s.active = true
GROUP BY t.id"
    stmt = nil
    results = nil
    queues = {}
    DB.use do |db|
      stmt = db.prepare(sql)
      results = stmt.execute()
      results.each do |row|
        trigger = {
          id: row[:trigger_id],
          trigger_name: row[:trigger_name],
          queue_name: row[:queue_name],
          script_id: row[:script_id],
          script_name: row[:script_name],
          description: row[:script_description],
          script: row[:script_script],
          last_run: row[:last_run]
        }
        queues[trigger[:queue_name]] = [] if !queues.has_key? trigger[:queue_name]
        queues[trigger[:queue_name]].push(trigger)
      end
    end
    return queues
  end
end
