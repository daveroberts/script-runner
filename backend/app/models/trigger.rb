# manages triggers in database
class Trigger
  def self.columns
    [:id, :script_id, :type, :active, :every, :queue_name, :created_at]
  end

end
