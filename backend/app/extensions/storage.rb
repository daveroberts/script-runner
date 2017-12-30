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
          get: {
            summary: "Gets an item from storage which was saved with `save`",
            params: [
               { name:       "key",
                description: "Item key returned by save" },
            ],
            returns: {
              name: "item_container",
              description: "container has:\n:item - 'The requested item'"
            }
          },
          by_tag: {
            summary: "Gets a bunch of item keys",
            params: [
               { name:       "tag",
                description: "Which data items to get" },
               { name:       "since",
                description: "Hash with one of the following:\nminutes, hours, days, weeks, months" },
            ],
            returns: {
              name: "array",
              description: "array of keys"
            }
          },
          remove: {
            summary: "remove an item from storage",
            params: [
               { name:       "key",
                description: "key of item to remove" }
            ],
            returns: {
              name: "int",
              description: "number of items removed"
            }
          }
        },
      }
    end
    def save(item, options = {
      summary: nil,
      image_id: nil,
      tag: nil,
      tags: nil,
      key: nil,
    })
      DataItem.save(item, options)
    end

    def get(key)
      item = DataItem.get(key)
      return nil if !item
      item[:item]
    end

    def by_tag(tag, since={
    })
      items = DataItem.by_tag(tag, since)
      items.map{|item|item[:key]}
    end

    def remove(key)
      raise "not implemented"
    end
  end
end
