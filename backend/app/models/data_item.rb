# manages data items in database
class DataItem
  def self.columns
    [:id, :key, :item, :item_mime_type, :created_at]
  end

  def self.add(item, item_mime_type = "text/plain", tags=[], key=nil)
    key = SecureRandom.uuid if key.blank?
    data_item_fields = {
      id: SecureRandom.uuid,
      key: key,
      item: item,
      item_mime_type: item_mime_type,
      created_at: Time.now
    }
    result = DataMapper.insert("data_items", data_item_fields)
    tags.each do |tag|
      tag_fields = {
        id: SecureRandom.uuid,
        data_item_key: key,
        name: tag,
        created_at: Time.now
      }
      result = DataMapper.insert("tags", tag_fields)
    end
    key
  end

  def self.by_tag(tag)
    DataItem.by_tags([tag])
  end

  def self.by_tags(tags)
    sql = "SELECT
  di.`id` as di_id, di.`key` as di_key, di.`item_mime_type` as di_item_mime_type, di.`created_at` as di_created_at,
  #{Tag.columns.map{|c|"t.`#{c}` as t_#{c}"}.join(",")}
FROM data_items di
  LEFT JOIN tags t on di.`key`=t.data_item_key
WHERE t.name IN (#{tags.map{|t|"'#{t}'"}.join(",")})
    "
    DataMapper.select(sql, {
      prefix: 'di',
      has_many: [
        { tags: { prefix: 't' } }
      ]
    })
  end

  def self.find(key)
    sql = "SELECT
  #{DataItem.columns.map{|c|"di.`#{c}` as di_#{c}"}.join(",")},
  #{Tag.columns.map{|c|"t.`#{c}` as t_#{c}"}.join(",")}
FROM data_items di
  LEFT JOIN tags t on di.`key`=t.data_item_key
WHERE di.`key` = ?"
    data_item = DataMapper.select(sql, {
      prefix: 'di',
      has_many: [
        { tags: { prefix: 't' } }
      ]
    }, [key]).first
    return nil if !data_item
    data_item
  end

end
