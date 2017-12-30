require 'uri'
require 'json'
require './app/database/database.rb'
require './app/lib/data_mapper.rb'

# Adds a demo data set to the database
class DBSeed
  @scripts = [
    {
      id: '4a990719-1862-4fa2-b5f1-e26c8867faec',
      name: '01 - Simple Example',
      category: 'language_examples',
      code: <<-CODE,
numbers = [2,4,6,8,10]
map(numbers, (x)->{ x*x })
CODE
      http_endpoint: "simple",
      http_method: "GET",
      http_request_accept: nil,
      http_response_content_type: "application/json"
    },
    {
      id: '6e19474e-5552-4cb3-a15c-b734f1067e75',
      name: '04 - Numbers - Generate',
      category: 'queue_example',
      code: <<-CODE,
number = random(1,10)
queue.add('numbers', number)
number
CODE
      every: 1,
      extensions: ['Queue']
    },
    {
      id: '17c79465-9dc5-45bb-9894-c4553ca06b15',
      name: '05 - Numbers - Process',
      category: 'queue_example',
      default_input: '44',
      code: <<-CODE,
square = (x) -> {x*x}
number = input()
number = square(number)
number
CODE
      queue_name: 'numbers'
    },
    {
      id: 'eb07e93d-0d30-403d-aaac-ef1f46d32cdf',
      name: '06 - Data Storage',
      category: 'data_storage',
      code: <<-CODE,
my_report = {
  title: "Some Report on Brushing and Flossing",
  country: "USA",
  created_at: now(),
  body: "The American Dental Association recommends brushing and flossing"
}
storage.save(my_report, { summary: my_report[:title], tag: "dental_reports" })
set.add('alert_emails','somebody_else@example.com')
dictionary.add('countries', 'IND', {id: '4097ce38-4369-49b6-8521-f7ed2cbe8802', code: 'IND', name: 'India'})
"Data Stored"
CODE
      extensions: ["Storage","Set","Dictionary"]
    },
    {
       id: '0b2d252d-77de-48a4-992d-b094a4b7ae56',
       name: '07 - Data Retrieval',
       category: 'data_storage',
       code: <<-CODE,
report_keys = storage.by_tag("dental_reports")
countries = {}
foreach report_key in report_keys {
  report = storage.get(report_key)
  country_name = report[:country]
  country_info = dictionary.lookup('countries', country_name)
  if country_info { countries[country_info[:id]] = country_name }
}
{
  dental_report_countries: countries,
  hot_topics: set.all('hot_topics')
}
CODE
      extensions: ["Storage","Set","Dictionary"]
    },
    {
      id: 'ec1259c1-c7f4-450c-9037-188eeff597e2',
      name: '02 - Recursive Function',
      category: 'language_examples',
      code: <<-CODE,
numbers = [2,4,6,8,10]
fib = (n)->{
  if n == 0 {
    0
  } elsif n == 1 {
    1
  } else {
    fib(n-1) + fib(n-2)
  }
}
map(numbers, fib)
CODE
    },
    {
      id: 'd6f2a465-6702-444a-bc9d-8157cbd45e20',
      name: '03 - Other Language Features',
      category: 'language_examples',
      default_input: '["Monday","Tuesday","Wednesday"]',
      code: <<-CODE,
days = input()
push(days, 'Thursday')
foreach day in days {
  queue.add('days', day)
}

// Count up then down
counter = 0
loop {
  counter = counter + 1
  if counter >= 10 { break }
}
high_value = counter
while counter != 0 {
  counter = counter - 1
}
join(['Was: ', high_value, ' Counter ended at: ',counter])
CODE
      extensions: ["Queue"]
    },
    {
      id: '54ef5a07-a515-4bfb-8113-f1daf7810648',
      name: '08 - Basic Browsing',
      category: 'web',
      code: <<-CODE,
chrome.go_to_url('https://duckduckgo.com')
search_box = chrome.element({:name 'q'})
chrome.fill_in_textbox(search_box, 'Puppies')
chrome.submit_form(search_box)
chrome.click(chrome.element({link_text: 'Images'}))
raw_data = chrome.screenshot()
image_id = image.save(raw_data, "Puppy Search Results")
storage.save("Puppy Page", {
  tag: 'puppies',
  image_id: image_id
})
CODE
      extensions: ["Chrome", "Image", "Storage"]
    },
    {
      id: 'e4636472-d285-4934-bbc2-d1e350bc6491',
      name: '10 - GD - Scrape Press Releases',
      category: 'web',
      code: <<-CODE,
chrome.go_to_url('https://www.gd.com')
all_links = chrome.links()
links = filter(all_links, (link)->{
  match('^https://www.gd.com/news/press-releases/.*$', link)
})
pages_scraped = 0
foreach link in links {
  if set.has('gd_urls_scraped', link) { print("Skipping: "+link) next }
  //chrome.wait(random(5,15))
  made_it = chrome.go_to_url(link)
  if made_it == false { next }
  screenshot = chrome.screenshot()
  image_id = image.save(screenshot, link)
  page = {
    url: link,
    html: chrome.html(),
    scraped_at: now()
  }
  storage.save(page, { tag: 'gd_pages_raw', summary: page[:url], image_id: image_id })
  queue.add('gd_pages_raw', page, { tag: 'gd_pages_raw', summary: page[:url], image_id: image_id })
  set.add('gd_urls_scraped', link)
  pages_scraped = pages_scraped + 1
}
pages_scraped
CODE
      extensions: ["Chrome", "Set", "Image", "Storage", "Queue"]
    },
    {
      id: '7fd0301f-c011-4e37-a5a5-02361ad15bbc',
      name: '11 - GD - Process Press Releases',
      category: 'web',
      code: <<-CODE,
raw_page = input()
doc = nokogiri.document_from_html(raw_page[:html])
title = nokogiri.text_from_css(doc, '.pane-node-title > h1:nth-child(1)')
date = nokogiri.text_from_css(doc, '.view-mode-full > div:nth-child(1) > div:nth-child(1) > div:nth-child(1)')
body = text_from_css(doc, '.field-name-body > div:nth-child(1) > div:nth-child(1)')
scraped_date = raw_page[:scraped_at]
url = raw_page[:url]
page = {
  url: url,
  title: title,
  article_date date,
  scraped_date: scraped_date,
  body: body
}
storage.save(page, { tag: 'gd_pages_processed', summary: page[:title] })
queue.add('gd_pages_processed', page, { summary: page[:title] })
CODE
      extensions: ["Nokogiri", "Storage", "Queue"],
      queue_name: 'gd_pages_raw'
    },
    {
      id: '31ec019a-2f12-4639-a627-441f6906a591',
      name: '12 - GD - Flag articles with hot topics',
      category: 'web',
      code: <<-CODE,
find_hot_topics = (article)->{
  hot_topics = set.all('hot_topics')
  article_hot_topics = []
  foreach topic in hot_topics {
    regex = join(['/.*', topic, '.*/im'])
    if match(article, regex) != null {
      push(article_hot_topics, topic)
    }
  }
  return article_hot_topics
}

page = input()
title = page[:title]
body = page[:body]
url = page[:url]

hot_topics = find_hot_topics(body)
if len(hot_topics) == 0 { return null }

report = {
  url: url,
  title: title
}
storage.save(report, { tags: hot_topics })
email.send(
  set.all('alert_emails'),
  "ALERT: Article flagged: " + page[:title]
  page[:title] + " contains " + hot_topics.join(", ")
)
hot_topics
CODE
      extensions: ["Email", "Set", "Storage"],
      queue_name: "gd_pages_processed"
    }
  ]
  @queue_items = [
  ]
  @data_items = [
  ]
  @tags = [
  ]
  @dictionary_items = [
    { id: '2bcff45d-67fe-47d4-ade1-8d9437f1b8e4', name: 'countries', key: "USA", value: { id: '8a0d4c31-49e5-49da-9f4c-5c6d747fb49d', code: "USA", name: "United States"}.to_json },
    { id: '38723350-38e7-4f0d-8c78-a51789da8280', name: 'countries', key: "CAN", value: { id: '05db0534-a826-4dea-bfda-c415901c7aa2', code: "CAN", name: "Canada"}.to_json },
    { id: '92a4c1b8-a10d-4bec-937c-071802858276', name: 'countries', key: "MEX", value: { id: '93d225ce-019d-43d7-8d2b-5675d10f1acf', code: "MEX", name: "Mexico"}.to_json },
    { id: '33c04631-4952-4e24-ab68-756486af11d8', name: 'countries', key: "PAN", value: { id: 'af4a2829-bb9b-4ff9-9cbb-797d183b193f', code: "PAN", name: "Panama"}.to_json },
  ]
  @set_items = [
    { id: '35fbcda8-169e-4f6c-99c5-ba37790e6feb', name: 'alert_emails', value: 'dave.a.roberts@gmail.com' },
    { id: '8bf81b0b-2714-4fec-ada7-986f5af15a3d', name: 'alert_emails', value: 'bob@example.com' },
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
