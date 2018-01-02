class DataMapper

  def self.insert(table, values)
    stmt = nil
    sql = "INSERT INTO #{table} (#{values.keys.map{|key|"`#{key}`"}.join(",")}) VALUES (#{values.keys.map{|key|"?"}.join(",")})"
    DB.use do |db|
      stmt = db.prepare(sql)
      stmt.execute(*values.values)
      return db.affected_rows
    end
  end

  def self.update(table, values)
    stmt = nil
    sql = "UPDATE #{table} SET #{values.keys.map{|key|"`#{key}`=?"}.join(",")} WHERE id = ?"
    puts sql
    DB.use do |db|
      stmt = db.prepare(sql)
      stmt.execute(*values.values, values[:id])
      return db.affected_rows
    end
  end

  def self.delete(table, conditions)
    stmt = nil
    sql = "DELETE FROM #{table} WHERE #{conditions.map{|k,v|"`#{k}` = ?"}.join(" AND ")}"
    DB.use do |db|
      stmt = db.prepare(sql)
      stmt.execute(*conditions.values)
      return db.affected_rows
    end
  end

  def self.raw_select(sql, variables = [])
    DB.use do |db|
      stmt = db.prepare(sql)
      results = stmt.execute(*variables)
      return results.to_a
    end
  end

  def self.select(sql, conf={}, variables = [])
    DB.use do |db|
      stmt = db.prepare(sql)
      results = stmt.execute(*variables)
      array = []
      results.each do |row|
        DataMapper.process_row(array, row, conf)
      end
      return array
    end
  end

  def self.process_row(array, row, conf)
    prefix = conf[:prefix]
    cols = row.keys.select{|k|k.to_s.start_with? "#{prefix}_"}
    obj = array.detect{|a|a[:id]==row["#{prefix}_id".to_sym]}
    brand_new = obj == nil
    obj = Hash.new if brand_new
    any = false
    cols.each do |col|
      any = true if row[col]
      obj[col[prefix.length+1..-1].to_sym] = row[col]
    end
    if conf.has_key? :has_many
      conf[:has_many].each do |rel|
        name = rel.keys.first
        obj[name] = [] if !obj.has_key? name
        self.process_row(obj[name], row, rel[name])
      end
    end
    if conf.has_key? :has_one
      conf[:has_one].each do |rel|
        name = rel.keys.first
        arr = nil
        if obj.has_key?(name) && obj[name]
          arr = [obj[name]]
        else
          arr = []
          obj[name] = nil
        end
        self.process_row(arr, row, rel[name])
        obj[name] = arr[0] if arr.length > 0
      end
    end
    array.push(obj) if any && brand_new
  end

end
