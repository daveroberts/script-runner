require 'uri'
require 'json'
require './app/database/database.rb'
require './app/lib/data_mapper.rb'

# Adds a demo data set to the database
class DBSeed
  @scripts = [
    { id: '4a990719-1862-4fa2-b5f1-e26c8867faec', name: 'Sample', code: "numbers = input()\nmap(numbers, (x)->{ x*x })" },
    { id: '6e19474e-5552-4cb3-a15c-b734f1067e75', name: 'Ingest', code: "number = random(1,10)\nqueue('numbers', number)" },
    { id: '17c79465-9dc5-45bb-9894-c4553ca06b15', name: 'Process', code: "number = arg()\nsave('numbers',number)" },
  ]
  @triggers = [
    { id: '32aaec50-fc57-42eb-b7d6-e634ba69a9b8', script_id: @scripts[1][:id], type: "CRON", every: 1 },
    { id: '59805e73-01cd-4185-98a7-f1bb582cae27', script_id: @scripts[2][:id], type: "QUEUE", queue_name: 'numbers' },
  ]
  @script_runs = [
    { id: 'b541d40e-9cd5-485a-a0e2-87d0e1a020f5', script_id: @scripts[0][:id], trigger_id: nil, input: '[2,4,6,8,10]', code:@scripts[0][:code], output: "[4,16,36,64,100]", run_at: DateTime.new(2017, 12, 6)},
    { id: '27ca4650-6c6d-4a23-a588-c34d8b5377bc', script_id: @scripts[1][:id], trigger_id: @triggers[0][:id], code:@scripts[1][:code], output: "4", run_at: DateTime.new(1982, 7, 15)},
    { id: 'd19c8caa-ec49-4cc1-824b-2bb2f78c61f9', script_id: @scripts[1][:id], trigger_id: @triggers[0][:id], code:@scripts[1][:code], output: "7", run_at: DateTime.new(1776, 7, 4)},
    { id: '6684f5e4-518a-4b08-855a-dcc24327a60b', script_id: @scripts[2][:id], trigger_id: @triggers[1][:id], code:@scripts[2][:code], output: "", run_at: DateTime.new(2017, 12, 4)},
    { id: '0e2336da-4e49-4233-a491-70ea8b77e7a2', script_id: @scripts[2][:id], trigger_id: @triggers[1][:id], code:@scripts[2][:code], output: "", run_at: DateTime.new(2017, 12, 5)},
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
    puts "Added #{@script_runs.count} script runs"
    @triggers.each do |trigger|
      values = {
        id: trigger[:id],
        script_id: trigger[:script_id],
        type: trigger[:type],
        every: trigger[:every],
        queue_name: trigger[:queue_name],
        active: true,
        created_at: DateTime.now
      }
      DataMapper.insert("triggers", values)
    end
    puts "Added #{@triggers.count} triggers"
    puts 'Done seeding DB'
  end
end
