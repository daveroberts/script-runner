require './app/database/database.rb'

# manages triggers in database
class Trigger
  def self.all
    conditions = []
    triggers = DataMapper.all("triggers", conditions)
    return triggers
  end
end
