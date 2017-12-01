require './app/database/database.rb'

# manages script runs in database
class ScriptRun

  def self.last_run(trigger_id)
    sql = "SELECT run_at FROM script_runs WHERE trigger_id = ? ORDER BY run_at DESC LIMIT 1"
    stmt = nil
    results = nil
    DB.use do |db|
      stmt = db.prepare(sql)
      results = stmt.execute()
      binding.pry
    end
  end

end
