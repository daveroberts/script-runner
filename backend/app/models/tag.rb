# manages tags in database
class Tag
  def self.columns
    [:id, :tagged_id, :tagged_type, :name, :created_at]
  end

  def self.names
    sql = "SELECT DISTINCT t.name FROM tags t ORDER BY t.name ASC"
    tags = DataMapper.raw_select(sql)
    tags.map{|t|t[:name]}
  end
end
