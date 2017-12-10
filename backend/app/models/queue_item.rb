require './app/database/database.rb'
require 'securerandom'

# manages scripts in database
class QueueItem

  def self.columns
    [:id, :queue_name, :state, :item_key, :item, :item_mime_type, :created_at]
  end

  def self.add(name, item, item_mime_type='application/json', item_key=nil)
    item_key=SecureRandom.uuid if item_key.blank?
    fields = {
      id: SecureRandom.uuid,
      queue_name: name,
      state: 'NEW',
      item_key: item_key,
      item: item,
      item_mime_type: item_mime_type,
      created_at: Time.now
    }
    DataMapper.insert("queue_items", fields)
  end

  def self.new_items
    sql = "SELECT #{@columns.map{|c|"qi.#{c} as qi_#{c}"}.join(',')}
           FROM queue_items qi
           WHERE qi.state = 'NEW'
           ORDER BY qi.created_at DESC"
    DataMapper.select(sql, { prefix: 'qi' })
  end

  def self.by_queue_name(name)
    sql = "
SELECT
  qi.`id` as qi_id,
  qi.`queue_name` as qi_queue_name,
  qi.`state` as qi_state,
  qi.`item_key` as qi_item_key,
  qi.`item_mime_type` as qi_item_mime_type,
  qi.`created_at` as qi_created_at,
  s.`id` as s_id,
  s.name as s_name
FROM queue_items qi
  LEFT JOIN triggers t ON qi.queue_name=t.queue_name AND t.active=true
  LEFT JOIN scripts s on t.script_id=s.id AND s.active=true
WHERE qi.queue_name = ?
ORDER BY qi.created_at DESC"
    DataMapper.select(sql, { prefix: 'qi', has_many: [
      { scripts: { prefix: 's' } }
    ] }, [name])
  end

  def self.by_item_key(key)
    sql = "
SELECT
  #{QueueItem.columns.map{|c|"qi.`#{c}` as qi_#{c}"}.join(",")},
  #{Trigger.columns.map{|c|"t.`#{c}` as t_#{c}"}.join(",")},
  #{Script.columns.map{|c|"s.`#{c}` as s_#{c}"}.join(",")}
FROM queue_items qi
  LEFT JOIN triggers t ON qi.queue_name=t.queue_name AND t.active=true
  LEFT JOIN scripts s on t.script_id=s.id AND s.active=true
WHERE qi.item_key = ?
ORDER BY qi.created_at DESC"
    DataMapper.select(sql, { prefix: 'qi', has_many: [{
       triggers: {
         prefix: 't',
         has_one: [
           { script: { prefix: 's' } }
         ]
       }
    }] }, [key]).first
  end

  def self.names
    sql = "SELECT DISTINCT qi.queue_name FROM queue_items qi ORDER BY qi.queue_name ASC"
    queues = DataMapper.raw_select(sql)
    queues.map{|q|q[:queue_name]}
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
