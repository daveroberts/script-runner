# manages tags in database
class Tag
  def self.columns
    [:id, :data_item_key, :name, :created_at]
  end

  def self.names
    sql = "SELECT DISTINCT t.name FROM tags t ORDER BY t.name ASC"
    tags = DataMapper.raw_select(sql)
    tags.map{|t|t[:name]}
  end
end
