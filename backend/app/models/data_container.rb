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

  def self.create(collection, data)
    dc = DataContainer.new(collection, data)
    $data[collection] = [] if !$data.has_key?(collection)
    $data[collection].push(dc)
    return dc
  end

  def self.find(collection, criteria)
    $data[collection].detect do |item|
      criteria.each do |k,v|
        return false if item[k] != v
      end
      true
    end
  end
end
