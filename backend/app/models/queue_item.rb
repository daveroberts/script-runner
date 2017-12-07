require './app/database/database.rb'
require 'securerandom'

# manages scripts in database
class QueueItem

  @columns = [:id, :queue_name, :state, :item_key, :item, :created_at]

  def self.add(name, item, item_key=nil)
    item_key=SecureRandom.uuid if item_key.blank?
    fields = {
      id: SecureRandom.uuid,
      queue_name: name,
      state: 'NEW',
      item_key: item_key,
      item: item,
      created_at: Time.now
    }
    DataMapper.insert("queue_items", fields)
  end

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

  def self.names
    sql = "SELECT DISTINCT qi.queue_name as qi_queue_name FROM queue_items qi"
    queues = DataMapper.select(sql, {
      prefix: 'qi',
    })
    queues.map{|s|s[:queue_name]}
  end

  def self.lock_for_processing(id)
    sql = "UPDATE queue_items SET state='PROCESSING' WHERE state='NEW' AND id=?"
    stmt = nil
    results = nil
    DB.use do |db|
      stmt = db.prepare(sql)
      results = stmt.execute(id)
      return db.affected_rows
    end
  end

  def self.finish_processing(id)
    sql = "UPDATE queue_items SET state='DONE' WHERE state='PROCESSING' AND id=?"
    stmt = nil
    results = nil
    DB.use do |db|
      stmt = db.prepare(sql)
      results = stmt.execute(id)
      return db.affected_rows
    end
  end

end
