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
  @queue_items = [
    { id: 'b57bf943-072c-47eb-88db-e3c55fc32190', queue_name: 'numbers', state: 'NEW', item_key: '58c6fe21-cb16-4847-b3dd-171c5d6888e0', item: '4' },
    { id: 'e8fb67c4-99fd-43f3-8552-f2cd13b740f8', queue_name: 'numbers', state: 'NEW', item_key: 'd18f2231-cea2-4e92-b7a3-3c0603e16c8e', item: '8' },
    { id: 'b7151457-4f3d-4fed-a0ef-b7f5d9f631d8', queue_name: 'numbers', state: 'NEW', item_key: '4b5ca664-43c0-48f2-a7e2-e590533876f9', item: '15' },
    { id: '35081bef-384b-4c63-8f1c-99644b8664e9', queue_name: 'numbers', state: 'NEW', item_key: '6132c06b-7b4f-4ff4-90d0-8a75781c9b48', item: '16' },
    { id: '8afec2ab-cb78-41c2-aa56-b307057d4e94', queue_name: 'numbers', state: 'PROCESSED', item_key: '7627c311-ec03-4d63-9c79-e0bddb97cd63', item: '23' },
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
    @queue_items.each do |qi|
      values = {
        id: qi[:id],
        queue_name: qi[:queue_name],
        state: qi[:state],
        item_key: qi[:item_key],
        item: qi[:item],
        created_at: DateTime.now
      }
      DataMapper.insert("queue_items", values)
    end
    puts "Added #{@queue_items.count} queue_items"
    puts 'Done seeding DB'
  end
end
