# manages tags in database
class Tag
  def self.columns
    [:id, :tagged_id, :tagged_type, :name, :created_at]
  end

  def self.names
    sql = "SELECT DISTINCT t.name FROM tags t ORDER BY t.name ASC"
    sql = "
SELECT
  t.name,
  count(t.id) as total
FROM tags t
GROUP BY t.name
ORDER BY t.name
"
    tags = DataMapper.raw_select(sql)
  end
end
