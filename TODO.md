duplicate detection
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
          type: JSON | string | image,
        }
      ],
      values: [
        {
          value: "",
          thumbnail_image_id: "",
          image_key: "",
          highlight: null | warning | danger
        }
      ]
    }
  ]
}

Queue.add(item, options={
  summary: nil,
  thumbnail_image_id: nil,
})
Queue.next()
Queue.process(item_id)
Queue.error(item_id, msg = '')
Queue.delete(item_id)

Storage.save(item, summary = nil, thumbnail_key = nil, tags = [], key = nil)
Storage.retrieve(key)
Storage.get_keys(tags=[], within=nil)
  within: X minutes, X hours, X days
Storage.delete(key)

Set.add(set_name, item)
Set.get_items(set_name)
Set.has_item(set_name, item)
Set.remove_item(set_name, item)

Dictionary.add_entry(dictionary_name, key, value, summary = nil, thumbnail_key = nil)
Dictionary.get_entry(dictionary_name, name)
Dictionary.get_all_entries(dictionary_name)

Document.new(document_id=nil)
Document.get(document_id)
Document.delete(document_id)

doc.set(key, value, type = 'TEXT', summary = nil, thumbnail_key = nil)
doc.get(key)
doc.add(key, value, summary = nil, thumbnail_key = nil)

Date functions
Output wrap to next line when browser window small
text summary on data, instead of showing a table of keys, make it indexable
common thread ID and view (family ID?)
store document type with key value pairs
listed vs unlisted dictionary
push dictionary, set, data through queue
immutable data types, versioning, push v1 through queue
dictionary "special" fields, image, preview, summary, id, family ID?
see logs as script runs, with thumbnails, lists of data, etc.
document
  id varchar 255 unique
  created_at
  summary varchar 255
  image longblob png
  image_preview longblob png x by y
  properties
    name
    type: short text, long text, image, array
    mime_type
    value
integrate with AWS S3

show data flow diagram; show problems solved; show commands can be complex, not primitive; one section of pipeline can be c  complex, etc.; vs S3, queues can be dynamically named, data sets dynamically created.  LocalDataStorage vs AwsDataStorage
  doesn't need to use custom script, could be any language with eval or scripting capability
debug mode - shows debug messages, what's being stored, what's happening, etc.
test mode - when true, doesn't actually store anything, just "pretends" and stores to memory or elsewhere
triggers on other data types; manually "dequeing" other data types
pull off queue manually
move js modules out of bundle
sending tweets
