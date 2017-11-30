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
    scripts = DataMapper.all(sql, {
      main: :script,
      relations: [
        script: [{ type: :has_many, prefix: :trigger }],
        trigger: [{ type: :belongs_to, prefix: :script, by: :script_id }]
      ]
    })
    return scripts
  end
end
