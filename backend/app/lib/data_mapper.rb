class DataMapper
  def self.all(sql)
    stmt = nil
    results = nil
    array = nil
    variables = []
    DB.use do |db|
      stmt = db.prepare(sql)
      results = stmt.execute(*variables)
      array = results.to_a.map{ |row| row_to_hash(row) }
    end
    return array
  end

  def self.insert(table, values)
    stmt = nil
    sql = "INSERT INTO #{table} (#{values.keys.map{|key|"`#{key}`"}.join(",")}) VALUES (#{values.keys.map{|key|"?"}.join(",")})"
    DB.use do |db|
      stmt = db.prepare(sql)
      stmt.execute(*values.values)
    end
  end

  def self.row_to_hash(row)
    return row
  end
end
