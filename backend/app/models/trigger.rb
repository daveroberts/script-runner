require './app/database/database.rb'

# manages triggers in database
class Trigger

  def self.all
    sql = "
SELECT
  t.id as t_id,
  t.name as t_name,
  s.id as s_id,
  s.name as s_name,
  s.code as s_code
FROM triggers t
  LEFT JOIN scripts s on t.script_id=s.id
    "
    DataMapper.select(sql, {
      prefix: 't',
      has_one: [
        { script: { prefix: 's' } }
      ]
    })
  end

end
