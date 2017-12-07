# manages data items in database
class DataItem
  def self.columns
    [:id, :key, :item, :created_at]
  end

  def self.add(item, tags=[], key=nil)
    key = SecureRandom.uuid if key.blank?
    data_item_fields = {
      id: SecureRandom.uuid,
      key: key,
      item: item,
      created_at: Time.now
    }
    DataMapper.insert("data_items", data_item_fields)
    tags.each do |tag|
      tag_fields = {
        id: SecureRandom.uuid,
        data_item_key: key,
        name: tag,
        created_at: Time.now
      }
      DataMapper.insert("tags", tag_fields)
    end
  end

  def self.by_tags(tags)
    sql = "SELECT
  #{DataItem.columns.map{|c|"di.`#{c}` as di_#{c}"}.join(",")},
  #{Tag.columns.map{|c|"t.`#{c}` as t_#{c}"}.join(",")}
FROM data_items di
  LEFT JOIN tags t on di.`key`=t.data_item_key
WHERE t.name IN (#{tags.map{|t|"'#{t}'"}.join(",")})
    "
    data_items = DataMapper.select(sql, {
      prefix: 'di',
      has_many: [
        { tags: { prefix: 't' } }
      ]
    })
    data_items.map{|di|di[:item]}
  end

  def self.find(key)
    sql = "SELECT
  #{DataItem.columns.map{|c|"di.`#{c}` as di_#{c}"}.join(",")},
  #{Tag.columns.map{|c|"t.`#{c}` as t_#{c}"}.join(",")}
FROM data_items di
  LEFT JOIN tags t on di.`key`=t.data_item_key
WHERE di.`key` = ?
    "
    data_item = DataMapper.select(sql, {
      prefix: 'di',
      has_many: [
        { tags: { prefix: 't' } }
      ]
    }, key).first
    return nil if !data_item
    data_item[:item]
  end

end
