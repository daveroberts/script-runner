require 'securerandom'

class DataQueue
  def initialize
  end

  def queue(name, item, item_key=nil)
    QueueItem.add(name, item, item_key)
  end

  def store(item, key=nil, tags=[])
    DataItem.add(item, key, tags)
  end

  def retrieve(key)
    DataItem.find(key)
  end

  def retrieve_by_tags(tags)
    DataItem.by_tags(tags)
  end

  def set_store(name, value)
    SetItem.add(name, value)
  end

  def set_retrieve(name)
    SetItem.by_name(name)
  end

  def set_has_value?(name, value)
    SetItem.has_value?(name, value)
  end

  def dict_store(name, key, value)
    DictionaryItem.add(name, key, value)
  end

  def dict_retrieve(name, key)
    DictionaryItem.find(name, key)
  end

  def dict_values(name)
    DictionaryItem.values(name)
  end

end
