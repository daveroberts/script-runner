require 'uri'
require 'json'
require './app/database/database.rb'

# Adds a demo data set to the database
class DBSeed
  def self.seed
    puts 'Seeding database'
    puts 'Done seeding DB'
  end
end
