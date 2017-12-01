class DataMapper

  def self.insert(table, values)
    stmt = nil
    sql = "INSERT INTO #{table} (#{values.keys.map{|key|"`#{key}`"}.join(",")}) VALUES (#{values.keys.map{|key|"?"}.join(",")})"
    DB.use do |db|
      stmt = db.prepare(sql)
      stmt.execute(*values.values)
    end
  end

end
