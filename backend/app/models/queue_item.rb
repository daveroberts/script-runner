require './app/database/database.rb'
require 'securerandom'

# manages scripts in database
class QueueItem

  def self.new_items
    sql = "
SELECT
  qi.id,
  qi.queue_name,
  qi.state,
  qi.item,
  qi.created_at
FROM queue_items qi
WHERE qi.state = 'NEW'
ORDER BY qi.created_at ASC"
    stmt = nil
    results = nil
    items = []
    DB.use do |db|
      stmt = db.prepare(sql)
      results = stmt.execute()
      results.each do |row|
        items.push(row)
      end
    end
    return items
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
