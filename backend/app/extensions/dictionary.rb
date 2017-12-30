require 'securerandom'

module SimpleLanguage
  class Dictionary
    def self._info
      {
        icon: "fa-book",
        summary: "Namespaced key value storage",
        methods: {
          add: {
            summary: "Add an item to a dictionary",
            params: [
             { name:         "dictionary_name",
               description:  "Name of the dictionary" },
             { name:         "key",
               description:  "Key of item to store" },
             { name:         "item",
               description:  "Item you wish to save to the set" },
            ],
            returns: {
              name: "int",
              description: "1 if item is added to the dictinary.  0 if the item already existed in the dictionary or could not be saved"
            }
          },
          lookup: {
            summary: "Get an item from a dictionary",
            params: [
             { name:        "dictionary_name",
              description:  "Name of the dictionary" },
             { name:        "key",
               description: "Key of item to retrieve" },
            ],
            returns: {
              name: "item or null",
              description: "Returns the item if found, null if not"
            }
          },
          remove: {
            summary: "Remove an item from a dictionary",
            params: [
             { name:        "dictionary_name",
              description:  "Name of the dictionary" },
             { name:        "key",
               description: "Key of item to retrieve" },
            ],
            returns: {
              name: "int",
              description: "1 if the item is removed, 0 if no item found or not removed"
            }
          },
          all: {
            summary: "Retrieve all items from the dictionary.  Warning: Some dictionaries may be very large",
            params: [
             { name:        "dictionary_name",
              description:  "Name of the dictionary" },
            ],
            returns: {
              name: "array",
              description: "All items from the dictionary"
            }
          },
        },
      }
    end

    def initialize(trace)
      @trace = trace
    end

    def add(dictionary_name, key, item)
    end

    def lookup(dictionary_name, key)
      item = DictionaryItem.lookup(dictionary_name, key)
      return nil if !item
      item[:value]
    end

    def remove(dictionary_name, key)
    end

    def all(dictionary_name)
    end
  end
end
