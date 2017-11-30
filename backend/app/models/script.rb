require './app/database/database.rb'

DataMapper.register("scripts", {
  :columns => [
    :id,
    :name,
    :description,
    :script,
    :active,
    :created_at
  ]
})

# manages scripts in database
class Script
  def self.all
    conditions = []
    scripts = DataMapper.all("scripts", conditions)
    binding.pry
    return scripts
  end
end
