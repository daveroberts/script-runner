require 'securerandom'

class DataQueue
  def initialize
  end

  def queue(name, item)
    item = {
      id: SecureRandom.uuid,
      queue_name: name,
      state: 'NEW',
      item: item,
      created_at: Time.now
    }
    DataMapper.insert("queue_items", item)
  end
end
