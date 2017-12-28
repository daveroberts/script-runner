require 'uri'
require 'json'
require './app/database/database.rb'
require './app/lib/data_mapper.rb'

# Adds a demo data set to the database
class DBSeed
  @scripts = [
    { id: '4a990719-1862-4fa2-b5f1-e26c8867faec', name: '01 - Simple Example', category: 'language_examples', code: "numbers = [2,4,6,8,10]\nmap(numbers, (x)->{ x*x })" },
    { id: '6e19474e-5552-4cb3-a15c-b734f1067e75', name: '04 - Numbers - Generate', category: 'queue_example', code: "number = random(1,10)\nqueue('numbers', number)\nnumber" },
    { id: '17c79465-9dc5-45bb-9894-c4553ca06b15', name: '05 - Numbers - Process', category: 'queue_example', default_input: '44', code: "number = int(input())\nnumber = number + 100\nnumber" },
    { id: '0b2d252d-77de-48a4-992d-b094a4b7ae56', name: '07 - Data Retrieval', category: 'data_storage', code: "logs = map(retrieve_by_tag('logs'), (key)->{ retrieve(key) })\n{\n  :countries dict_values('countries'),\n  :logs logs,\n  :topics set_retrieve('hot_topics')\n}" },
    { id: 'eb07e93d-0d30-403d-aaac-ef1f46d32cdf', name: '06 - Data Storage', category: 'data_storage', code: "store(join(['fake log data: ', now()]),'text/plain',['logs'])\nset_store('gd_alert_emails','dave.a.roberts@gmail.com')\ndict_store('countries', '4097ce38-4369-49b6-8521-f7ed2cbe8802', {:code 'IND', :name 'India'})" },
    { id: 'ec1259c1-c7f4-450c-9037-188eeff597e2', name: '02 - Recursive Function', category: 'language_examples', code: "numbers = [2,4,6,8,10]\nfib = (n)->{\n  if n == 0 {\n    0\n  } elsif n == 1 {\n    1\n  } else {\n    fib(n-1) + fib(n-2)\n  }\n}\nmap(numbers, fib)" },
    { id: 'd6f2a465-6702-444a-bc9d-8157cbd45e20', name: '03 - Other Language Features', category: 'language_examples', default_input: '["Monday","Tuesday","Wednesday"]', code: "days = input()\npush(days, 'Thursday')\nforeach day in days {\n  queue('days', day, 'text/plain')\n}\n\n// Count up then down\ncounter = 0\nloop {\n  counter = counter + 1\n  if counter >= 10 { break }\n}\nhigh_value = counter\nwhile counter != 0 {\n  counter = counter - 1\n}\njoin(['Was: ', high_value, ' Counter ended at: ',counter])" },
    { id: '54ef5a07-a515-4bfb-8113-f1daf7810648', name: '08 - Google Search', category: 'web', code: "go_to_url('http://google.com')\nsearch_box = element({:name 'q'})\nfill_in_textbox(search_box, 'XOR security')\nsubmit_form(search_box)\nraw_data = get_screenshot()\nstore(raw_data, 'image/png', ['images', 'xor'])", extensions: ["Chrome"] },
    { id: 'e4636472-d285-4934-bbc2-d1e350bc6491', name: '10 - GD - Scrape Press Releases', category: 'web', code: "go_to_url('https://www.gd.com')\nall_links = get_links()\nlinks = filter(all_links, (link)->{match(link, '^https:\/\/www\.gd\.com\/news\/press-releases\/.*$')})\npages_scraped = 0\nforeach link in links {\n  if set_has_value('gd_urls_scraped', link) { next }\n  //wait(random(5,15))\n  made_it = go_to_url(link)\n  if made_it == false { next }\n  html = get_html()\n  today = now()\n  screenshot = get_screenshot()\n  screenshot_key = store(screenshot, 'image/png', ['gd_images'])\n  page = { :url link, :html html, :scraped_at today, :screenshot_key screenshot_key }\n  store(page, 'application/json', ['gd', 'gd_pages_raw'])\n  queue('gd_pages_raw', page, 'application/json')\n  set_store('gd_urls_scraped', link)\n  pages_scraped = pages_scraped + 1\n}\npages_scraped", extensions: ["Chrome"] },
    { id: '7fd0301f-c011-4e37-a5a5-02361ad15bbc', name: '11 - GD - Process Press Releases', category: 'web', code: "raw_page = input()\ndoc = document_from_html(raw_page[:html])\ntitle = text_from_css(doc, '.pane-node-title > h1:nth-child(1)')\ndate = text_from_css(doc, '.view-mode-full > div:nth-child(1) > div:nth-child(1) > div:nth-child(1)')\nbody = text_from_css(doc, '.field-name-body > div:nth-child(1) > div:nth-child(1)')\nscraped_date = raw_page[:scraped_at]\nscreenshot_key = raw_page[:screenshot_key]\nurl = raw_page[:url]\npage = {\n  :url url,\n  :title title,\n  :article_date date,\n  :scraped_date scraped_date,\n  :screenshot_key screenshot_key,\n  :body body\n}\nstore(page, 'application/json', ['gd', 'gd_pages_processed'])\nqueue('gd_pages_processed', page, 'application/json')", extensions: ["LocalDataStorage", "HtmlXmlParser"] },
    { id: '31ec019a-2f12-4639-a627-441f6906a591', name: '12 - GD - Flag articles with hot topics', category: 'web', code: "find_hot_topics = (article)->{\n  hot_topics = set_retrieve('hot_topics')\n  article_hot_topics = []\n  foreach topic in hot_topics {\n    regex = join(['/.*', topic, '.*/im'])\n    if match(article, regex) != null {\n      push(article_hot_topics, topic)\n    }\n  }\n  return article_hot_topics\n}\n\npage = input()\ntitle = page[:title]\nbody = page[:body]\nurl = page[:url]\n\nhot_topics = find_hot_topics(body)\ncontains_hot_topics = len(hot_topics) > 0\nkey = null\n\nif contains_hot_topics {\n  gd_hot_topics = map(hot_topics, (t)->{ join(['gd_hot_topic_', t]) })\n  report = {\n    :url url,\n    :title title\n  }\n  key = store(report, 'application/json', gd_hot_topics)\n  send_email('system@mail.daveroberts.us', set_retrieve('gd_alert_emails'), join(['ALERT: Article flagged: ', page[:title]]), join(['Article at ', page[:title], ' - ', page[:url], ' contains: ', join(gd_hot_topics)]))\n}\nkey", extensions: ["Email", "LocalDataStorage"] },
    { id: '0a317597-d028-4f55-bf97-a76786bb50ef', name: '09 - SFTP Ingestion', category: '', code: "sftp_connect('hostname','username','password')\nfiles = sftp_dir('.')\nforeach file in files {\n  content = sftp_download(file)\n  queue('sftp_raw_files', content)\n  sftp_delete(file)\n}\nsftp_disconnect()", extensions: ["LocalDataStorage", "Sftp"] },
    { id: '6d018621-7b4e-4532-9390-51ff604981fa', name: '13 - XML ingestion', category: '', code: "xml = input()\nchecksum = hash(xml)\nalready_seen = set_has_value('indicators_documents_processed', checksum)\nif already_seen { return false }\ndoc = document_from_xml(xml)\nitems = xpath(doc, '//indicator')\narr = []\nforeach item in items {\n  item_type = attribute_from_node(item, 'type')\n  item_value = text_from_node(item)\n  push(arr, {:type item_type, :value item_value})\n  set_store(item_type, item_value)\n}\nstore(arr, 'application/json', ['indicator_reports'])\nqueue('indicator_reports', arr, 'application/json')\nset_store('indicators_documents_processed', checksum)\narr", default_input: "<report>\n  <name>Analysis Report 123</name>\n  <indicators>\n    <indicator type='domain'>google.com</indicator>\n    <indicator type='domain'>nytimes.com</indicator>\n    <indicator type='domain'>cleveland.com</indicator>\n    <indicator type='ipv4'>10.10.174.66</indicator>\n    <indicator type='ipv6'>2001:0db8:0a0b:12f0:0000:0000:0000:0001</indicator>\n  </indicators>\n</report>", extensions: ["LocalDataStorage", "HtmlXmlParser"] },
  ]
  @triggers = [
    { id: '32aaec50-fc57-42eb-b7d6-e634ba69a9b8', script_id: @scripts[1][:id], type: "CRON", every: 1 },
    { id: '59805e73-01cd-4185-98a7-f1bb582cae27', script_id: @scripts[2][:id], type: "QUEUE", queue_name: 'numbers' },
    { id: '599bf88f-4a4f-48db-b58e-ded0fa9326f7', script_id: @scripts[9][:id], type: "QUEUE", queue_name: 'gd_pages_raw' },
    { id: '6ea76729-1ff7-44fb-9073-114d19fbe0b9', script_id: @scripts[10][:id], type: "QUEUE", queue_name: 'gd_pages_processed' },
    { id: '53332d6f-191e-4916-a21a-54722b880332', script_id: @scripts[0][:id], type: "HTTP", http_endpoint: 'simple', http_method: 'GET' },
    { id: 'b00fe095-a3cf-45f2-9324-c7a5da89fc8b', script_id: @scripts[2][:id], type: "HTTP", http_endpoint: 'number_crunch', http_method: 'POST' },
    { id: '7561a648-0126-499c-a3d2-c259e284260e', script_id: @scripts[12][:id], type: "HTTP", http_endpoint: 'indicators', http_method: 'POST' },
  ]
  @queue_items = [
  ]
  @data_items = [
  ]
  @tags = [
  ]
  @dictionary_items = [
    { id: '2bcff45d-67fe-47d4-ade1-8d9437f1b8e4', name: 'countries', key: '8a0d4c31-49e5-49da-9f4c-5c6d747fb49d', value: { code: "USA", name: "United States"}.to_json },
    { id: '38723350-38e7-4f0d-8c78-a51789da8280', name: 'countries', key: '05db0534-a826-4dea-bfda-c415901c7aa2', value: { code: "CAN", name: "Canada"}.to_json },
    { id: '92a4c1b8-a10d-4bec-937c-071802858276', name: 'countries', key: '93d225ce-019d-43d7-8d2b-5675d10f1acf', value: {  code: "MEX", name: "Mexico"}.to_json },
    { id: '33c04631-4952-4e24-ab68-756486af11d8', name: 'countries', key: 'af4a2829-bb9b-4ff9-9cbb-797d183b193f', value: { code: "PAN", name: "Panama"}.to_json },
  ]
  @set_items = [
    { id: '35fbcda8-169e-4f6c-99c5-ba37790e6feb', name: 'gd_alert_emails', value: 'dave.a.roberts@gmail.com' },
    { id: '8bf81b0b-2714-4fec-ada7-986f5af15a3d', name: 'gd_alert_emails', value: 'bob@example.com' },
    { id: '56498833-3beb-49f1-ae3d-20aa4375cada', name: 'hot_topics', value: 'navy' },
    { id: 'bb24aa77-2cee-4282-b196-c57bdd73fbde', name: 'hot_topics', value: 'contract' },
    { id: 'e78851e2-cc72-4bc8-8c84-6883c534d56b', name: 'hot_topics', value: 'awarded' },
  ]
  def self.seed
    puts 'Seeding database'
    @scripts.each do |script|
      extensions = script[:extensions].to_json
      extensions = [].to_json if !script[:extensions]
      values = {
        id: script[:id],
        name: script[:name],
        category: script[:category],
        description: "Sample description",
        default_input: script[:default_input],
        extensions: extensions,
        code: script[:code],
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
        type: trigger[:type],
        every: trigger[:every],
        queue_name: trigger[:queue_name],
        http_endpoint: trigger[:http_endpoint],
        http_method: trigger[:http_method],
        http_content_type: 'application/json',
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
        item_mime_type: 'text/plain',
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
        item_mime_type: "text/plain",
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
        summary: o[:value],
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
