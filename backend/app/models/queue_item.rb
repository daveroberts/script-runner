require './app/database/database.rb'
require 'securerandom'

# manages scripts in database
class QueueItem

  @columns = [:id, :queue_name, :state, :script_run_id, :item_key, :item, :created_at]

  def self.new_items
    sql = "SELECT #{@columns.map{|c|"qi.#{c} as qi_#{c}"}.join(',')}
           FROM queue_items qi
           WHERE qi.state = 'NEW'
           ORDER BY qi.created_at ASC"
    DataMapper.select(sql, { prefix: 'qi' })
  end

  def self.by_queue_name(name)
    sql = "SELECT #{@columns.map{|c|"qi.#{c} as qi_#{c}"}.join(',')}
           FROM queue_items qi
           WHERE qi.queue_name = ?
           ORDER BY qi.created_at ASC"
    DataMapper.select(sql, { prefix: 'qi' }, [name])
  end

  def self.process(id)
    sql = "UPDATE queue_items SET state='PROCESSING' WHERE state='NEW' AND id=?"
    stmt = nil
    results = nil
    DB.use do |db|
      stmt = db.prepare(sql)
      results = stmt.execute(id)
      return db.affected_rows
    end
  end

end
