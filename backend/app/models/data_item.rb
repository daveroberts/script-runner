require 'mini_magick'
require 'securerandom'

# manages data items in database
class DataItem
  def self.columns
    [:key, :item, :summary, :image_id, :created_at]
  end

  def self.save(item, options={
    summary: nil,
    image_id: nil,
    tag: nil,
    tags: nil,
    key: nil
  })
    key = options[:key] ? options[:key] : SecureRandom.uuid
    fields = {
      key: key,
      item: item.to_json,
      summary: options[:summary] ? options[:summary].to_json : item.to_json,
      image_id: options[:image_id],
      created_at: Time.now
    }
    result = DataMapper.insert("data_items", fields)
    if options[:tag] || options[:tags]
      raise Exception, "tag or tags, choose one" if options[:tag] && options[:tags]
      tags = options[:tags] if options[:tags]
      tags = [options[:tag]] if options[:tag]
      tags.each do |tag|
        tag_fields = {
          id: SecureRandom.uuid,
          data_item_key: key,
          name: tag,
          created_at: Time.now
        }
        result = DataMapper.insert("tags", tag_fields)
      end
    end
    key
  end

  def self.by_tag(tag, by={
    within: nil
  })
    tags = nil
    tags = tag if tag.class == Array
    tags = [tag]
sql = <<~SQL
SELECT
  image_id,
  summary,
  `key`,
  di.created_at
FROM data_items di
LEFT JOIN tags t on di.`key` = t.data_item_key
WHERE
  t.name IN (#{tags.map{|t|"'#{t}'"}.join(",")})
ORDER BY t.created_at
SQL
    results = DataMapper.raw_select(sql)
    results
  end

  def self.get(key)
    sql = "SELECT
  #{DataItem.columns.map{|c|"di.`#{c}` as di_#{c}"}.join(",")}
FROM data_items di
WHERE di.`key` = ?"
    data_item = DataMapper.select(sql, {
      prefix: 'di',
      has_many: [
      ]
    }, [key]).first
    return nil if !data_item
    data_item[:item] = JSON.parse(data_item[:item], symbolize_names: true)
    data_item
  end

  def self.delete(key)
    DataMapper.delete("data_items", {key: key})
  end

end
