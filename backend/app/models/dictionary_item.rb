# manages dictionary items in database
class DictionaryItem
  def self.columns
    [:id, :name, :key, :value]
  end

  def self.add(name, key, value)
    fields = {
      id: SecureRandom.uuid,
      name: name,
      key: key,
      value: value,
      created_at: Time.now
    }
    DataMapper.insert("dictionary_items", fields)
  end

  def self.find(name, key)
    sql = "SELECT
  #{DictionaryItem.columns.map{|c|"di.`#{c}` as di_#{c}"}.join(",")}
FROM dictionary_items di
WHERE di.`name`=? AND di.`key` = ?"
    item = DataMapper.select(sql, {
      prefix: 'di',
    }, [name, key]).first
    return nil if !item
    JSON.parse(item[:value])
  end

  def self.names
    sql = "SELECT DISTINCT d.name as d_name FROM dictionary_items d"
    dictionaries = DataMapper.select(sql, {
      prefix: 'd',
    })
    dictionaries.map{|d|d[:name]}
  end

  def self.values(name)
    sql = "SELECT
  #{DictionaryItem.columns.map{|c|"di.`#{c}` as di_#{c}"}.join(",")}
FROM dictionary_items di
WHERE di.`name`=?"
    dictionary_items = DataMapper.select(sql, {
      prefix: 'di',
    }, name)
    dict = Hash.new
    dictionary_items.each do |di|
      dict[di[:key]] = JSON.parse(di[:value])
    end
    return dict
  end

end
