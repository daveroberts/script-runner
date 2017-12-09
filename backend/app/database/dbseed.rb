require 'uri'
require 'json'
require './app/database/database.rb'
require './app/lib/data_mapper.rb'

# Adds a demo data set to the database
class DBSeed
  @scripts = [
    { id: '4a990719-1862-4fa2-b5f1-e26c8867faec', name: 'Sample', category: 'language_examples', code: "numbers = [2,4,6,8,10]\nmap(numbers, (x)->{ x*x })" },
    { id: '6e19474e-5552-4cb3-a15c-b734f1067e75', name: 'Ingest', category: 'queue_example', code: "number = random(1,10)\nqueue('numbers', number)\nnumber" },
    { id: '17c79465-9dc5-45bb-9894-c4553ca06b15', name: 'Process', category: 'queue_example', default_test_input: '44', code: "number = int(input())\nnumber = number + 100\nnumber" },
    { id: '0b2d252d-77de-48a4-992d-b094a4b7ae56', name: 'Data Retrieval', category: 'data_storage', code: "{\n  :countries dict_values('countries'),\n  :pages retrieve_by_tag('pages'),\n  :urls set_retrieve('urls')\n}" },
    { id: 'eb07e93d-0d30-403d-aaac-ef1f46d32cdf', name: 'Data Storage', category: 'data_storage', code: "store('fake log data',['logs'])\nset_store('names','Dave')\ndict_store('employees', 'Dave', {:id 4,:name 'Dave'})" },
    { id: 'ec1259c1-c7f4-450c-9037-188eeff597e2', name: 'Recursive Function', category: 'language_examples', code: "numbers = [2,4,6,8,10]\nfib = (n)->{\n  if n == 0 {\n    0\n  } elsif n == 1 {\n    1\n  } else {\n    fib(n-1) + fib(n-2)\n  }\n}\nmap(numbers, fib)" },
  ]
  @triggers = [
    { id: '32aaec50-fc57-42eb-b7d6-e634ba69a9b8', script_id: @scripts[1][:id], type: "CRON", every: 1 },
    { id: '59805e73-01cd-4185-98a7-f1bb582cae27', script_id: @scripts[2][:id], type: "QUEUE", queue_name: 'numbers' },
  ]
  @script_runs = [
    { id: 'b541d40e-9cd5-485a-a0e2-87d0e1a020f5', script_id: @scripts[0][:id], trigger_id: nil, input: '[2,4,6,8,10]', code:@scripts[0][:code], output: "[4,16,36,64,100]", run_at: DateTime.new(2017, 12, 6)},
    { id: '27ca4650-6c6d-4a23-a588-c34d8b5377bc', script_id: @scripts[1][:id], trigger_id: @triggers[0][:id], code:@scripts[1][:code], output: "4", run_at: DateTime.new(1982, 7, 15)},
    { id: 'd19c8caa-ec49-4cc1-824b-2bb2f78c61f9', script_id: @scripts[1][:id], trigger_id: @triggers[0][:id], code:@scripts[1][:code], output: "7", run_at: DateTime.new(1776, 7, 4)},
    { id: '6684f5e4-518a-4b08-855a-dcc24327a60b', script_id: @scripts[2][:id], trigger_id: @triggers[1][:id], input: "7", code:@scripts[2][:code], output: "107", run_at: DateTime.new(2017, 12, 4)},
    { id: '0e2336da-4e49-4233-a491-70ea8b77e7a2', script_id: @scripts[2][:id], trigger_id: @triggers[1][:id], input: "9", code:@scripts[2][:code], output: "109", run_at: DateTime.new(2017, 12, 5)},
  ]
  @queue_items = [
    { id: 'b57bf943-072c-47eb-88db-e3c55fc32190', queue_name: 'numbers', state: 'NEW', item_key: '58c6fe21-cb16-4847-b3dd-171c5d6888e0', item: '4' },
    { id: 'e8fb67c4-99fd-43f3-8552-f2cd13b740f8', queue_name: 'numbers', state: 'NEW', item_key: 'd18f2231-cea2-4e92-b7a3-3c0603e16c8e', item: '8' },
    { id: 'b7151457-4f3d-4fed-a0ef-b7f5d9f631d8', queue_name: 'numbers', state: 'NEW', item_key: '4b5ca664-43c0-48f2-a7e2-e590533876f9', item: '15' },
    { id: '35081bef-384b-4c63-8f1c-99644b8664e9', queue_name: 'numbers', state: 'NEW', item_key: '6132c06b-7b4f-4ff4-90d0-8a75781c9b48', item: '16' },
    { id: '8afec2ab-cb78-41c2-aa56-b307057d4e94', queue_name: 'numbers', state: 'DONE', item_key: '7627c311-ec03-4d63-9c79-e0bddb97cd63', item: '23' },
  ]
  @data_items = [
    { id: 'c8853cd1-c93a-45fe-a3cc-085fe75bfe3e', key: '3b3074b2-47a7-4f62-b163-a664224ef52b', item: "Google - Don't be evil" },
    { id: 'd3e867c1-ba08-472a-a3f3-318a7b0fc1e5', key: '8746b969-1666-4810-83f8-e667b77fa64a', item: 'CNN - The most trusted name in news' },
    { id: 'e462129d-1be9-478b-8b86-ee4f037f9682', key: '031a3d59-a42e-4764-8e13-c515a2c3c210', item: 'Fair and Balanced' },
    { id: '892d5a3f-798d-42f9-afbc-462637380dd5', key: 'aa9ee163-b6f3-407d-ab00-940c2ed1ba8d', item: 'Do the right thing' },
  ]
  @tags = [
    { id: 'aeccec6b-9d01-4522-80e1-a61b798b8ce9', data_item_key: @data_items[0][:key], dictionary_item_key: nil, name: 'pages' },
    { id: '403d6d01-9d04-4a08-a95e-91f24aa1c465', data_item_key: @data_items[1][:key], dictionary_item_key: nil, name: 'pages' },
    { id: '57266aea-b905-43fe-b642-31d7f609fc82', data_item_key: @data_items[2][:key], dictionary_item_key: nil, name: 'pages' },
    { id: '6154cd42-ac2e-4cb0-b4bd-206382a55335', data_item_key: @data_items[3][:key], dictionary_item_key: nil, name: 'pages' },
  ]
  @dictionary_items = [
    { id: '2bcff45d-67fe-47d4-ade1-8d9437f1b8e4', name: 'countries', key: 'USA', value: {id: "8a0d4c31-49e5-49da-9f4c-5c6d747fb49d", name: "United States"}.to_json },
    { id: '38723350-38e7-4f0d-8c78-a51789da8280', name: 'countries', key: 'CAN', value: {id: "05db0534-a826-4dea-bfda-c415901c7aa2", name: "Canada"}.to_json },
    { id: '92a4c1b8-a10d-4bec-937c-071802858276', name: 'countries', key: 'MEX', value: {id: "93d225ce-019d-43d7-8d2b-5675d10f1acf", name: "Mexico"}.to_json },
    { id: '33c04631-4952-4e24-ab68-756486af11d8', name: 'countries', key: 'PAN', value: {id: "af4a2829-bb9b-4ff9-9cbb-797d183b193f", name: "Panama"}.to_json },
  ]
  @set_items = [
    { id: '35fbcda8-169e-4f6c-99c5-ba37790e6feb', name: 'urls', value: 'http://www.google.com' },
    { id: '8bf81b0b-2714-4fec-ada7-986f5af15a3d', name: 'urls', value: 'http://www.cnn.com' },
    { id: 'e88fa93d-a4b7-4b51-9906-6e961066c7a9', name: 'urls', value: 'http://www.foxnews.com' },
    { id: '04b2ebd9-fe0f-4c15-b3aa-0a378c9e8d06', name: 'urls', value: 'http://gmail.com' },
  ]
  def self.seed
    puts 'Seeding database'
    @scripts.each do |script|
      values = {
        id: script[:id],
        name: script[:name],
        category: script[:category],
        description: "Sample description",
        default_test_input: script[:default_test_input],
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
        input: run[:input],
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
    @data_items.each do |o|
      values = {
        id: o[:id],
        key: o[:key],
        item: o[:item],
        created_at: DateTime.now
      }
      DataMapper.insert("data_items", values)
    end
    puts "Added #{@data_items.count} data_items"
    @tags.each do |o|
      values = {
        id: o[:id],
        data_item_key: o[:data_item_key],
        name: o[:name],
        created_at: DateTime.now
      }
      DataMapper.insert("tags", values)
    end
    puts "Added #{@tags.count} tags"
    @dictionary_items.each do |o|
      values = {
        id: o[:id],
        name: o[:name],
        key: o[:key],
        value: o[:value],
        created_at: DateTime.now
      }
      DataMapper.insert("dictionary_items", values)
    end
    puts "Added #{@dictionary_items.count} dictionary_items"
    @set_items.each do |o|
      values = {
        id: o[:id],
        name: o[:name],
        value: o[:value],
        created_at: DateTime.now
      }
      DataMapper.insert("set_items", values)
    end
    puts "Added #{@set_items.count} set_items"
    puts 'Done seeding DB'
  end
end
