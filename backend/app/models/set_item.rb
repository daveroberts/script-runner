# manages store items in database
class SetItem
  def self.columns
    [:id, :name, :value, :created_at]
  end

  def self.add(name, value)
    fields = {
      id: SecureRandom.uuid,
      name: name,
      value: value,
      created_at: Time.now
    }
    DataMapper.insert("set_items", fields)
  end

  def self.by_name(name)
    sql = "SELECT
  #{SetItem.columns.map{|c|"si.`#{c}` as si_#{c}"}.join(",")}
FROM set_items si
WHERE si.name = ?"
    set_items = DataMapper.select(sql, {
      prefix: 'si'
    }, name)
    set_items.map{|si|si[:value]}
  end

  def self.has_value?(name, value)
    sql = "SELECT si.id as si_id
FROM set_items si
WHERE si.name = ? AND si.value=?"
    DataMapper.select(sql, {
      prefix: 'si'
    }, [name, value]).any?
  end

  def self.names
    sql = "SELECT DISTINCT s.name as s_name FROM set_items s"
    sets = DataMapper.select(sql, {
      prefix: 's',
    })
    sets.map{|s|s[:name]}
  end

end
