require './app/database/database.rb'

# manages script runs in database
class ScriptRun

  def self.columns
    [:id, :script_id, :input, :code, :output, :error, :run_at]
  end

  def self.add(script_run)
    fields = self.script_run_to_fields(script_run)
    DataMapper.insert("script_runs", fields)
  end

  def self.script_run_to_fields(script_run)
    script_run[:id] = SecureRandom.uuid if !script_run[:id]
    fields = {}
    self.columns.each do |col|
      if col == :output
        fields[:output] = script_run[:output].to_json
      else
        fields[col] = script_run[col]
      end
    end
    fields
  end

  def self.last_n(script_id, n)
    sql = "SELECT
  #{ScriptRun.columns.map{|c|"sr.`#{c}` as sr_#{c}"}.join(",")}
FROM script_runs sr
WHERE sr.script_id = ?
ORDER BY sr.run_at DESC
LIMIT ?
    "
    rows = DataMapper.select(sql, {
      prefix: 'sr',
      has_many: [
      ]
    }, [script_id, n])
    script_runs = rows_to_script_runs(rows)
    script_runs
  end

  def self.rows_to_script_runs(rows)
    script_runs = []
    rows.each do |row|
      script_run = row
      script_run[:output] = JSON.parse(row[:output], symbolize_names: true)
      script_runs.push(script_run)
    end
    return script_runs
  end

end
