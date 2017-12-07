# manages tags in database
class Tag
  def self.columns
    [:id, :data_item_key, :name, :created_at]
  end

  def self.names
    sql = "SELECT DISTINCT t.name as t_name FROM tags t"
    tags = DataMapper.select(sql, {
      prefix: 't',
    })
    tags.map{|t|t[:name]}
  end
end
