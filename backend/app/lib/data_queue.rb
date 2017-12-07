require 'securerandom'

class DataQueue
  def initialize
  end

  def queue(name, item, item_key=nil)
    item_key=SecureRandom.uuid if item_key.blank?
    item = {
      id: SecureRandom.uuid,
      queue_name: name,
      state: 'NEW',
      item_key: item_key,
      item: item,
      created_at: Time.now
    }
    DataMapper.insert("queue_items", item)
  end

  def store(set, key, value)
  end

  def has_key?(set, key)
  end

  def retrieve(set, key)
  end

  def save(set, data)
  end

  def log(set, msg)
  end
end
