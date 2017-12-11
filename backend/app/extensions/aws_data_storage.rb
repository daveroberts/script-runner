require 'securerandom'

class AwsDataStorage
  def self.icon
    "fa-cloud"
  end

  def initialize
  end

  # Totally fake, doesn't do anything
  def queue(name, item, item_mime_type='application/json', item_key=nil)
    return true
  end

  # Totally fake, doesn't do anything
  def store(item, item_mime_type='application/json', tags=[], key=nil)
    return true
  end

  # Totally fake, doesn't do anything
  def retrieve(key)
    return true
  end

  # Totally fake, doesn't do anything
  def retrieve_by_tag(tag)
    return true
  end

  # Totally fake, doesn't do anything
  def retrieve_by_tags(tags)
    return true
  end

  # Totally fake, doesn't do anything
  def set_store(name, value)
    return true
  end

  # Totally fake, doesn't do anything
  def set_retrieve(name)
    return true
  end

  # Totally fake, doesn't do anything
  def set_has_value(name, value)
    return true
  end

  # Totally fake, doesn't do anything
  def dict_store(name, key, value)
    return true
  end

  # Totally fake, doesn't do anything
  def dict_retrieve(name, key)
    return true
  end

  # Totally fake, doesn't do anything
  def dict_values(name)
    return true
  end

end
