require './app/database/database.rb'
require 'securerandom'

# manages scripts in database
class QueueItem

  def self.columns
    [:id, :queue_name, :state, :item, :summary, :image_id, :created_at]
  end

  def self.add(queue_name, item, options={
    summary: nil,
    image_id: nil
  })
    image_id = options[:image_id]
    fields = {
      id: SecureRandom.uuid,
      queue_name: queue_name,
      state: 'NEW',
      item: item.to_json,
      summary: options[:summary] ? options[:summary].to_json : item.to_json,
      image_id: options[:image_id],
      created_at: Time.now
    }
    DataMapper.insert("queue_items", fields)
  end

  def self.delete(id)
    DataMapper.delete("queue_items", {id: id})
  end

  def self.requeue(id)
    DataMapper.update("queue_items", {id: id, state: 'NEW'})
  end

  # Locks the next item ready for processing
  def self.next(queue_name = nil)
    item_ids = QueueItem.items_ready_for_processing(queue_name)
    item_ids.each do |item_id|
      locked = QueueItem.lock_for_processing(item_id)
      next if !locked
      return QueueItem.get(item_id)
    end
    return nil
  end

  def self.process(queue_item_id)
    sql = "UPDATE queue_items SET state='DONE', locked_at=NULL WHERE id=? AND locked_at IS NOT NULL"
    stmt = nil
    results = nil
    DB.use do |db|
      stmt = db.prepare(sql)
      results = stmt.execute(id)
      return db.affected_rows
    end
  end

  def self.items_ready_for_processing(queue_name = nil)
    queue_clause = queue_name ? "AND qi.queue_name = ?" : ""
    variables = []
    variables.push(queue_name) if queue_name
    sql = "
SELECT
  qi.id
FROM queue_items qi
  LEFT JOIN scripts s on s.trigger_queue=TRUE AND s.queue_name=qi.queue_name
WHERE
  qi.state='NEW' #{queue_clause}
ORDER BY qi.created_at ASC"
    ids = DataMapper.raw_select(sql, variables)
    return ids.map{|row|row[:id]}
  end

  def self.by_queue_name(queue_name)
    sql = "
SELECT
  qi.`id` as qi_id,
  qi.`queue_name` as qi_queue_name,
  qi.`state` as qi_state,
  qi.`summary` as qi_summary,
  qi.`image_id` as qi_image_id,
  qi.`created_at` as qi_created_at,
  s.`id` as s_id,
  s.name as s_name
FROM queue_items qi
  LEFT JOIN scripts s on qi.queue_name=s.queue_name
WHERE qi.queue_name = ?
ORDER BY qi.created_at DESC"
    items = DataMapper.select(sql, { prefix: 'qi', has_many: [
      { scripts: { prefix: 's' } }
    ] }, [queue_name])
    items.each do |item|
      item[:summary] = JSON.parse(item[:summary], symbolize_names: true)
    end
    items
  end

  def self.get(id)
    sql = "
SELECT
  #{QueueItem.columns.map{|c|"qi.`#{c}` as qi_#{c}"}.join(",")},
  #{Script.columns.map{|c|"s.`#{c}` as s_#{c}"}.join(",")}
FROM queue_items qi
  LEFT JOIN scripts s on qi.queue_name=s.queue_name
WHERE qi.id = ?
ORDER BY qi.created_at DESC"
    item = DataMapper.select(sql, { prefix: 'qi', has_one: [
        { script: { prefix: 's' } }
      ]
    }, [id]).first
    return nil if !item
    item[:item] = JSON.parse(item[:item], symbolize_names: true)
    item[:summary] = JSON.parse(item[:summary], symbolize_names: true)
    item
  end

  def self.names
    sql = "SELECT DISTINCT qi.queue_name FROM queue_items qi ORDER BY qi.queue_name ASC"
    queues = DataMapper.raw_select(sql)
    queues.map{|q|q[:queue_name]}
  end

  def self.lock_for_processing(id)
    sql = "UPDATE queue_items SET state='PROCESSING', locked_at=NOW() WHERE state='NEW' AND id=?"
    stmt = nil
    results = nil
    DB.use do |db|
      stmt = db.prepare(sql)
      results = stmt.execute(id)
      return db.affected_rows
    end
  end

  def self.error_processing(id)
    sql = "UPDATE queue_items SET state='ERROR', locked_at=NULL WHERE state='PROCESSING' AND id=?"
    stmt = nil
    results = nil
    DB.use do |db|
      stmt = db.prepare(sql)
      results = stmt.execute(id)
      return db.affected_rows
    end
  end

  def self.finish_processing(id)
    sql = "UPDATE queue_items SET state='DONE', locked_at=NULL WHERE state='PROCESSING' AND id=?"
    stmt = nil
    results = nil
    DB.use do |db|
      stmt = db.prepare(sql)
      results = stmt.execute(id)
      return db.affected_rows
    end
  end
end
