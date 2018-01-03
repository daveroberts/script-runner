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
    begin
      rows_added = DataMapper.insert("set_items", fields)
      return true
    rescue Mysql2::Error => e
      return false if e.to_s.include?("Duplicate entry")
      raise e
    end
  end

  def self.delete(id)
    DataMapper.delete("set_items", {id: id})
  end

  def self.all(name)
    sql = "SELECT
  #{SetItem.columns.map{|c|"si.`#{c}` as si_#{c}"}.join(",")}
FROM set_items si
WHERE si.name = ?"
    DataMapper.select(sql, {
      prefix: 'si'
    }, name)
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
    sql = "
SELECT
  si.name,
  count(si.id) as total
FROM set_items si
GROUP BY si.name
ORDER BY si.name ASC
"
    row = DataMapper.raw_select(sql)
    sets = {}
    rows = DataMapper.raw_select(sql)
    rows.each do |row|
      sets[row[:name]] = row[:total]
    end
    sets
  end

end
