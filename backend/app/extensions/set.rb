require 'securerandom'

module SimpleLanguage
  class Set
    def self._info
      {
        icon: "fa-cutlery",
        summary: "Provides a way to store a unique set of strings",
        methods: {
          add: {
            summary: "Add an item to a set",
            params: [
             { name:         "set_name",
               description:  "Name of the set" },
             { name:         "item",
               description:  "Item you wish to save to the set" },
            ],
            returns: {
              name: "boolean",
              description: "true if item is added to the set.  false if the item already existed in the set"
            }
          },
          has: {
            summary: "See if item is in a set",
            params: [
               { name:        "set_name",
                 description: "Name of the set" },
               { name:        "item",
                 description: "Needle to find in the haystack" },
            ],
            returns: {
              name: "int",
              description: "1 if the item is in the set, 0 if not"
            }
          },
          remove: {
            summary: "Remove an item from a set",
            params: [
               { name:       "set_name",
                description: "Name of the set" },
               { name:       "item",
                description: "Item to remove" },
            ],
            returns: {
              name: "int",
              description: "1 if the item is removed, 0 if no item found or not removed"
            }
          },
          all: {
            summary: "Retrieve all items from the set.  Warning: Some sets may be very large",
            params: [
               { name:       "set_name",
                description: "Name of the set" },
            ],
            returns: {
              name: "array",
              description: "All items from the set"
            }
          },
        },
      }
    end

    def initialize(trace=[])
      @trace = trace
    end

    def add(set_name, item)
      SetItem.add(set_name, item)
    end

    def has(set_name, item)
      SetItem.has_value?(set_name, item)
    end

    def remove(set_name, item)
      raise "not yet implemented"
    end

    def all(set_name)
      items = SetItem.all(set_name)
      items.map{|item|item[:value]}
    end
  end
end
