require './app/database/database.rb'

DataMapper.register("triggers", {
  :columns => [
    :id,
    :script_id,
    :name,
    :info_type,
    :info_id,
    :active,
    :created_at
  ]
})

# manages triggers in database
class Trigger
  def self.all
    conditions = []
    triggers = DataMapper.all("triggers", conditions)
    return triggers
  end
end
