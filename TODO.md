"simple message", timestamp
Evaluated list <long list here> and selected <long list here>
{
  summary: "",
  detail: "",
  level: debug | info | warning | danger
  thumbnail_key: "",
  image_key: "",
  timestamp: "time",
  tables: [
    {
      title: "",
      headers: [
        {
          name: ""
          type: string | thumbnail,
        }
      ],
      values: [
        {
          value: "",
          thumbnail_key: "",
          image_key: "",
          highlight: null | warning | danger
        }
      ]
    }
  ]
}

Queue.add(payload, type = 'JSON', summary = nil, thumbnail_key = nil)
Queue.next()
Queue.process(item_id)
Queue.error(item_id, msg = '')
Queue.delete(item_id)

Storage.save(payload, type = 'JSON', summary = nil, thumbnail_key = nil, tags = [], key = nil)
Storage.retrieve(key)
Storage.get_keys(tags=[], within=nil)
  within: X minutes, X hours, X days
Storage.delete(key)

Set.add(set_name, item)
Set.get_items(set_name)
Set.has_item(set_name, item)
Set.remove_item(set_name, item)

Dictionary.add_entry(dictionary_name, name, payload, type = 'JSON', summary = nil, thumbnail_key = nil)
Dictionary.get_entry(dictionary_name, name)
Dictionary.get_all_entries(dictionary_name)

Document.new(document_id=nil)
Document.get(document_id)
Document.delete(document_id)

doc.set(key, value, type = 'TEXT', summary = nil, thumbnail_key = nil)
doc.get(key)
doc.add(key, value, summary = nil, thumbnail_key = nil)

Date functions
common thread ID and view
integrate with AWS S3

show data flow diagram; show problems solved; show commands can be complex, not primitive; one section of pipeline can be c  complex, etc.; vs S3, queues can be dynamically named, data sets dynamically created.  LocalDataStorage vs AwsDataStorage
  doesn't need to use custom script, could be any language with eval or scripting capability
debug mode - shows debug messages, what's being stored, what's happening, etc.
test mode - when true, doesn't actually store anything, just "pretends" and stores to memory or elsewhere
triggers on other data types; manually "dequeing" other data types
pull off queue manually
move js modules out of bundle
sending tweets
