class CustomSystemInteraction
  def self.icon
    "fa-bolt"
  end

  def initialize
  end

  # Retrieve data from system
  def custom_system_retreive(params)
    return ["one", "two", "three"]
  end

  # Send data to system
  def custom_system_send(data, metadata)
    return 1
  end

end
