require 'securerandom'

# Sets
# Dictionaries
# Documents
# Queues
# Arbitrary Data Items
# Tags
# Labels
# Log Messages
# Images with previews
class DocumentStorage
  def self.icon
    "fa-database"
  end

  def initialize
  end

  # Returns: Queue ID
  def queue(queue_name, item, options = {
    summary: summary,
    type: "JSON", # DOC, XML, TEXT, LONG_TEXT, LONG_INDEXED_TEXT, IMAGE
    image: image_data,
    tags: ['tag1','tag2'],
    tag: 'tag1',
    labels: ['label1','label2'],
    label: "some uuid"
  })
  end

  # returns key
  def save_item(item, options = {
    key: key,
    summary: summary,
    type: "JSON", # DOC, XML, TEXT, LONG_TEXT, LONG_INDEXED_TEXT, IMAGE
    image: image_data,
    tags: ['tag1','tag2'],
    tag: 'tag1',
    labels: ['label1','label2'],
    label: "some uuid"
  })
  end

  def get_item(key)
  end

  def get_items_keys_by_tag(tag)
  end

  def get_items_keys_by_label(tag)
  end

  def save_item_to_set(set_name, value)
  end

  def get_items_from_set(set_name)
  end

  def does_set_have_value(set_name, value)
  end

  def save_item_to_dictionary(dictionary_name, key, value)
  end

  def get_item_from_dictionary(dictionary_name, key)
  end

  def get_dictionary_values(dictionary_name)
  end

  def log(msg, options={
    tags: [],
    tag: "",
    labels: [],
    label: ""
  })
  end

  def get_document(document_id)
  end

  def save_value_on_document(document_id, prop_name, data=nil, type='TEXT', array=false, in_json=true)
  end

  def get_property_names(document_id)
  end

  # attach a tag to a document
  def tag_document(document_id, tag)
  end

  def get_documents_by_tag(tag)
  end
end
