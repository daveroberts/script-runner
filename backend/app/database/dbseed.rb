require 'uri'
require 'json'
require './app/database/database.rb'
require './app/lib/data_mapper.rb'

# Adds a demo data set to the database
class DBSeed
  @scripts = [
    { id: '4a990719-1862-4fa2-b5f1-e26c8867faec', name: 'Sample', code: "2+2" },
    { id: '6e19474e-5552-4cb3-a15c-b734f1067e75', name: 'Ingest', code: "number = random(1,10)\nqueue('numbers', number)" },
    { id: '17c79465-9dc5-45bb-9894-c4553ca06b15', name: 'Process', code: "number = arg()\nsave('numbers',number)" },
  ]
  @triggers = [
    { id: '32aaec50-fc57-42eb-b7d6-e634ba69a9b8', script_id: @scripts[1][:id], name: "Ingest every minute", info_type: "cron", info_id: "141bd623-37a9-41be-901f-d25c9528e991" },
    { id: '59805e73-01cd-4185-98a7-f1bb582cae27', script_id: @scripts[2][:id], name: "Process ingested items", info_type: "queue", info_id: "b5423a97-0107-4126-bcdd-cc53c19130fb" },
  ]
  @cron_triggers = [
    { id: @triggers[0][:info_id], every: 1 }
  ]
  @queue_triggers = [
    { id: @triggers[1][:info_id], queue_name: "numbers" }
  ]
  @script_runs = [
    { id: '27ca4650-6c6d-4a23-a588-c34d8b5377bc', script_id: @scripts[1][:id], trigger_id: @triggers[0][:id], code:"dummy", output: "dummy", run_at: DateTime.new(1982, 7, 15)},
    { id: 'd19c8caa-ec49-4cc1-824b-2bb2f78c61f9', script_id: @scripts[1][:id], trigger_id: @triggers[0][:id], code:"dummy", output: "dummy", run_at: DateTime.new(1776, 7, 4)},
  ]
  def self.seed
    puts 'Seeding database'
    @scripts.each do |script|
      values = {
        id: script[:id],
        name: script[:name],
        description: "Sample description",
        code: script[:code],
        active: true,
        created_at: DateTime.now
      }
      DataMapper.insert("scripts", values)
    end
    puts "Added #{@scripts.count} scripts"
    @script_runs.each do |run|
      values = {
        id: run[:id],
        script_id: run[:script_id],
        trigger_id: run[:trigger_id],
        code: run[:code],
        output: run[:output],
        run_at: run[:run_at]
      }
      DataMapper.insert("script_runs", values)
    end
    puts "Added #{@queue_triggers.count} queue_triggers"
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
    @cron_triggers.each do |trigger|
      values = {
        id: trigger[:id],
        every: trigger[:every]
      }
      DataMapper.insert("cron_triggers", values)
    end
    puts "Added #{@cron_triggers.count} cron_triggers"
    @queue_triggers.each do |trigger|
      values = {
        id: trigger[:id],
        queue_name: trigger[:queue_name]
      }
      DataMapper.insert("queue_triggers", values)
    end
    puts "Added #{@queue_triggers.count} queue_triggers"
    puts 'Done seeding DB'
  end
end
