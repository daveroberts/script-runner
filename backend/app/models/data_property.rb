# manages data properties in database
class DataItem
  def initialize(value)
    @value = value
  end

  def push(item)
    puts "push called on data item"
  end
end
