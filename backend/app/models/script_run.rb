require './app/database/database.rb'

# manages script runs in database
class ScriptRun

  def self.columns
    [:id, :script_id, :trigger_id, :queue_name, :queue_item_key, :input, :code, :output, :error, :run_at]
  end

  def self.last_n(script_id, n)
    sql = "SELECT
  #{ScriptRun.columns.map{|c|"sr.`#{c}` as sr_#{c}"}.join(",")},
  #{Trigger.columns.map{|c|"t.`#{c}` as t_#{c}"}.join(",")}
FROM script_runs sr
  LEFT JOIN triggers t on sr.trigger_id=t.script_id
WHERE sr.script_id = ?
ORDER BY sr.run_at DESC
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
