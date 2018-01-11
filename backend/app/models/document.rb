# manages Document objects
=begin
reference
  collection
  key

object
  collection: /countries
  id: "e3dd9efc-5840-425f-a99e-4e3cb5f65c21"
  key: "USA" or "e3dd9efc-5840-425f-a99e-4e3cb5f65c21"
  summary: "United States of America"
  type: string | number | file | image | queue_name | reference | document
  str_value:
  num_value:
  file_id:
  image_id:
  queue_name:
  referenced_object_id: 
  complex
  summary: America
  image_id
  values
  
metadata  
  id: <uuid>
  object_id: <uuid>
  key: "population"
  type: string | number | file | image | queue_name | reference | document
  array: boolean
  str_value:
  text_value:
  num_value: 365000000
  file_id:
  image_id:
  queue_name:
  referenced_object_id: 


object
  collection: /gd/urls_scraped
  key: "https://gd.com/press-releases/test.html"
  
object
  collection: /countries
  key: "e3dd9efc-5840-425f-a99e-4e3cb5f65c21"

object
  collection: /gd/files_received
  key: <auto-generated>
metadata
  object_id
  key: "title"
  str_value: "My document title"
metadata
  object_id
  key: "body"
  str_value: "My document body"
metadata
  object_id
  key: "languages"
  array: true
  reference_collection: "languages"
  reference_key: "ABC123"
metadata
  object_id
  key: "languages"
  array: true
  reference_collection: "languages"
  reference_key: "XYZ456"

page = data.save({
  collection: "gd/tps_reports",
  summary: "This is a TPS report",
  language: data.find("languages", "name", "English"),
  population: 275000,
  html: "some html here",
  retrieved_at: now()
})
url = "https://www.gd.com/press-releases/testing.html"

// check if URL has been scraped
data.find("gd/urls_scraped", {url: url})

// Add URL to collection
data.save({ collection: "gd/urls_scraped", url: url})

// Add a dictionary value
data.save({
  collection: "countries",
  summary: "United States of America",
  name: "United States of America",
  code: "USA",
  spoken_languages: [data.find("languages", {name: "English"})],
  population: 323100000,
})

country = data.find("countries", { code: "USA" })
print(country[:name])
country[:capital] = "Washington DC"
country[:spoken_languages] << data.find("languages", {name: "Spanish"})

// Does the country speak language Spanish?
spanish_language = country[:spoken_languages].detect((lang)->{lang[:name]=="Spanish"})

// Be able to find all countries which speak Spanish
data.find("countries", {spoken_languages: {name: "Spanish"}})

// Find all active admins
people = data.find("people", { admin: true, active: true})
// Get their email addresses and put them into an array
emails = map(people, (person)->{person[:email]})

// Alternatively, store a single admin mailing list, with an array of emails
mailing_list = data.find("mailing_lists" , { name: "administrators" })
emails = mailing_list[:emails]
// Add a name to this mailing list
mailing_list[:emails] << "dave.a.roberts@gmail.com"

=end
  
  
module SimpleLanguage
  class Document
    def initialize(options = {
      id: nil,
      values: {},
    })
      @id = options[:id]
      @values = options[:values]
    end

    def save
    end

    def self.get(id)
      values = DataMapper.raw_select(sql, id)
    end

    def set(key, value, options={
      type: 'string',
      value: ''
    })
    end

    def [](key)
      @values[key]
    end

    def []=(key, value)
      @values[key] = value
    end

    def to_json(opts=nil)
      return @values.to_json(opts)
    end

    def to_s
      return @values.to_s
    end
  end
end