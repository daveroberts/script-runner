require 'uri'
require 'json'
require './app/database/database.rb'
require './app/lib/data_mapper.rb'

# Adds a demo data set to the database
class DBSeed
  @scripts = [
    { id: '4a990719-1862-4fa2-b5f1-e26c8867faec', name: 'Sample', script: "2+2" }
  ]
  @triggers = [
    { id: '32aaec50-fc57-42eb-b7d6-e634ba69a9b8', script_id: @scripts[0][:id], name: "Trigger 1", info_type: "dummy", info_id: "dummy" },
    { id: 'a4fb5301-f4d7-46c8-86c3-fd991f91915c', script_id: @scripts[0][:id], name: "Trigger 2", info_type: "dummy", info_id: "dummy" }
  ]
  def self.seed
    puts 'Seeding database'
    @scripts.each do |script|
      values = {
        id: script[:id],
        name: script[:name],
        description: "Sample description",
        script: script[:script],
        active: true,
        created_at: DateTime.now
      }
      DataMapper.insert("scripts", values)
    end
    puts "Added #{@scripts.count} scripts"
    @triggers.each do |trigger|
      values = {
        id: trigger[:id],
        script_id: trigger[:script_id],
        name: trigger[:name],
        info_type: trigger[:info_type],
        info_id: trigger[:info_id],
        active: true,
        created_at: DateTime.now
      }
      DataMapper.insert("triggers", values)
    end
    puts "Added #{@triggers.count} triggers"
    puts 'Done seeding DB'
  end
end
