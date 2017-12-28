require 'securerandom'

module SimpleLanguage
  class Storage
    def self._info
      {
        icon: "fa-database",
        summary: "Provides a way to save data.  Any type of data can be saved.  If you want the data to be processed later, you should use the Queue instead",
        methods: {
          save: {
            summary: "Saves an item to local storage",
            params: [
              { name:        "item",
                description: "any data which you wish to save" },
              { name:        "options",
                description: "optional hash of values\nsummary - 'a short description of the item.  Must be parsable as JSON'\nimage_id - 'Used to show preview image'\ntag - 'single string to tag the item'\ntags - 'array of strings to tag the item'\nkey - 'The key to retrieve the item.  If not passed, a random key is assigned and returned'" },
            ],
            returns: {
              name: "item_id",
              description: "The item's key, which can be used to retrieve the item"
            }
          },
          retrieve: {
            summary: "Retrieves an item from storage which was saved with `save`",
            params: [
               { name:       "key",
                description: "Item key returned by save" },
            ],
            returns: {
              name: "item_container",
              description: "container has:\n:item - 'The requested item'"
            }
          }
        },
      }
    end
    def save(item, options = {
      summary: nil,
      image_id: nil,
      tag: nil,
      tags: [],
      key: nil,
    })
    end

    def self.retrieve(key)
    end

    # {
    #   "summary": "Retrieves item keys tagged with `tag`",
    #   "params": [
    #   { "name": "tag",
    #     "description": "The tag of the items you wish to retrieve" }
    #   ],
    #   "returns":
    #     { "name": "item_keys",
    #       "description": "An array of item keys" }
    # }
    def self.get_keys_by_tag(tag, withing=nil)
    end

    # {
    #   "summary": "Deletes an item",
    #   "params": [
    #   { "name": "key",
    #     "description": "The key of the item you wish to delete" }
    #   ],
    #   "returns":
    #     { "name": "int",
    #       "description": "1 if successful, 0 if not" }
    # }
    def self.delete(key)
    end
  end
end
