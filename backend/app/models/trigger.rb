# manages triggers in database
class Trigger
  def self.columns
    [:id, :script_id, :type, :active, :every, :queue_name, :http_endpoint, :http_method, :created_at]
  end
end
