require './app/database/database.rb'

# manages scripts in database
class Script

  def self.all
    sql = "
SELECT
  s.id as script_id,
  s.name as script_name,
  s.description as script_description,
  s.script as script_script,
  s.active as script_active,
  s.created_at as script_created_at,
  t.id as trigger_id,
  t.name as trigger_name,
  t.active as trigger_active,
  t.created_at as trigger_created_at
FROM scripts s
  LEFT JOIN triggers t on s.id=t.script_id "
    stmt = nil
    results = nil
    scripts = []
    variables = []
    DB.use do |db|
      stmt = db.prepare(sql)
      results = stmt.execute(*variables)
      results.each do |row|
        script = scripts.detect{|s|s[:id]==row[:script_id]}
        if !script
          script = {
            id: row[:script_id],
            name: row[:script_name],
            description: row[:script_description],
            script: row[:script_script],
            active: row[:script_active],
            created_at: row[:script_created_at],
            triggers: []
          }
          scripts.push(script)
        end
        if row[:trigger_id]
          trigger = script[:triggers].detect{|t|t[:id]==row[:trigger_id]}
          if !trigger
            trigger = {
              id: row[:trigger_id],
              name: row[:trigger_name],
              active: row[:trigger_active],
              created_at: row[:trigger_created_at]
            }
            script[:triggers].push(trigger)
          end
        end
      end
    end
    return scripts
  end
end
