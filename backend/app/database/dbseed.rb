require 'uri'
require 'json'
require './app/database/database.rb'
require './app/lib/data_mapper.rb'

# Adds a demo data set to the database
class DBSeed
  @scripts = [
    { id: '4a990719-1862-4fa2-b5f1-e26c8867faec', name: 'Sample', script: "2+2" }
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
    puts 'Done seeding DB'
  end
end
