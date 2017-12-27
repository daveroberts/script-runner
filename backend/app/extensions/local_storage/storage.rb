require 'securerandom'

module LocalStorage
  class Storage
    def self._icon
      "fa-database"
    end

    def initialize
    end

    # {
    #   "summary": "Saves an item to local storage",
    #   "params": [
    #   { "name": "item",
    #     "description": "any data which you wish to save" },
    #   { "name": "options",
    #     "description": "hash of values" },
    #   { "name": "options.summary",
    #     "description": "a short description of the item.  Must be parsable as JSON" },
    #   { "name": "options.image_id",
    #     "description": "Used to show preview image" },
    #   { "name": "options.tag",
    #     "description": "single string to tag the item" },
    #   { "name": "options.tags",
    #     "description": "array of strings to tag the item" },
    #   { "name":"options.key",
    #     "description":"The key to retrieve the item.  If not passed, a random key is assigned and returned" }
    #   ],
    #   "returns":
    #     { "name": "item_id",
    #       "description": "The item's key, which can be used to retrieve the item" }
    # }
    def self.save(item, options = {
      summary: nil,
      image_id: nil,
      tag: nil,
      tags: [],
      key: nil,
    })
    end

    # {
    #   "summary": "Retrieves an item from local storage",
    #   "params": [
    #   { "name": "key",
    #     "description": "The key for the item which you want to retireve" }
    #   ],
    #   "returns":
    #     { "name": "item",
    #       "description": "The stored item" }
    # }
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
