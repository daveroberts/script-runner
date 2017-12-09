require 'securerandom'

class LocalDataStorage
  def self.icon
    "fa-database"
  end

  def initialize
  end

  # Add `item` to queue with `name`.  Another script can read these items off of the queue.  You can optionally pass an item key for lookup later
  def queue(name, item, item_key=nil)
    QueueItem.add(name, item, item_key)
  end

  # Store a piece of data.  You can give it a key to look it up later, or you can tag it with one or more tags to look up all this data later.
  def store(item, tags=[], key=nil)
    DataItem.add(item, tags, key)
  end

  # Retrieve data stored with store() method by key
  def retrieve(key)
    DataItem.find(key)
  end

  # Retrieve data stored with store() method by tag
  def retrieve_by_tag(tag)
    DataItem.by_tag(tag)
  end

  # Retrieve data stored with store() method matching all tags in array
  def retrieve_by_tags(tags)
    DataItem.by_tags(tags)
  end

  # Store a value in a named set.  Will return false if item is already in set.
  def set_store(name, value)
    SetItem.add(name, value)
  end

  # Retrieve all items in set with `name`
  def set_retrieve(name)
    SetItem.by_name(name)
  end

  # Check if value exists in a set
  def set_has_value(name, value)
    SetItem.has_value?(name, value)
  end

  # store a `value` in dictionary `name` by `key`
  def dict_store(name, key, value)
    DictionaryItem.add(name, key, value)
  end

  # lookup a value in dictionary `name` by `key`
  def dict_retrieve(name, key)
    DictionaryItem.find(name, key)
  end

  # get all values in the dictionary `name`
  def dict_values(name)
    DictionaryItem.values(name)
  end

end
