require 'mini_magick'

# manages data items in database
class DataItem
  def self.columns
    [:id, :key, :item, :item_mime_type, :preview, :preview_mime_type, :created_at]
  end

  def self.add(item, item_mime_type = "text/plain", tags=[], key=nil)
    key = SecureRandom.uuid if key.blank?
    db_item = item
    db_item = item.to_json if item.class == Hash
    data_item_fields = {
      id: SecureRandom.uuid,
      key: key,
      item: db_item,
      item_mime_type: item_mime_type,
      created_at: Time.now
    }
    if /^image\/.*/.match(item_mime_type)
      thumb = MiniMagick::Image.read(db_item)
      thumb.resize "350x350"
      data_item_fields[:preview] = thumb.to_blob
      data_item_fields[:preview_mime_type] = thumb.mime_type
    else
    end
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
  di.`id` as di_id, di.`key` as di_key, di.`item_mime_type` as di_item_mime_type, di.`preview_mime_type` as di_preview_mime_type, di.`created_at` as di_created_at,
  #{Tag.columns.map{|c|"t.`#{c}` as t_#{c}"}.join(",")}
FROM data_items di
  LEFT JOIN tags t on di.`key`=t.data_item_key
WHERE t.name IN (#{tags.map{|t|"'#{t}'"}.join(",")})
ORDER BY di.created_at DESC
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
    if data_item[:item_mime_type] == 'application/json'
      data_item[:item] = JSON.parse(data_item[:item], symbolize_names: true)
    end
    data_item
  end

  def self.delete(key)
    DataMapper.delete("data_items", {key: key})
  end

end
