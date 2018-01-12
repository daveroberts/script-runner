# manages data items in database
class DataContainer
  $data = {}
  def initialize(collection, data)
    @collection = collection
    @values = data
  end

  def [](key)
    value = @values[key]
    value.extend Pusher
    value
  end

  def []=(key, value)
    @values[key] = value
  end

  def save()
    self
  end

  def to_json(opts = nil)
    @values.to_json(opts)
  end

  def self.save(collection, data)
    dc = DataContainer.new(collection, data)
    $data[collection] = [] if !$data.has_key?(collection)
    $data[collection].push(dc)
    return dc
  end

  def self.find(collection, criteria)
    return nil if !$data.has_key?(collection)
    $data[collection].detect do |item|
      criteria.each do |k,v|
        return false if item[k] != v
      end
      true
    end
  end

  def self.find_all(collection, criteria)
    return [] if !$data.has_key?(collection)
    items = $data[collection].select do |item|
      criteria.each do |k,v|
        return false if item[k] != v
      end
      true
    end
    items
  end
end
