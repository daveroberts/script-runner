implement http
  add http accept param
send input from queue
replace the word extensions with libraries
Do something with category on scripts
test input, not just JSON?
click images on basic browsing examples
trim off beginning slash on http endpoint on save
show snake case in helpers
increment operator
duplicate detection
  allow dictionary to function as a set
{
  summary: "",
  detail: "",
  level: debug | info | warning | danger
  image_id: "",
  show_image: false,
  timestamp: "time",
  show_tables: false,
  tables: [
    {
      title: "",
      headers: [
        {
          name: ""
          type: JSON | string | image,
        }
      ],
      rows: [
        [{
          value: "",
          thumbnail_image_id: "",
          image_key: "",
          highlight: null | warning | danger
        }]
      ]
    }
  ]
}

doc.set(key, value, summary = nil, image_id = nil)
doc.get(key)
doc.to_json()

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
investigate monaco editor integration
