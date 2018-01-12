require 'securerandom'

module SimpleLanguage
  class Data
    def self._info
      {
        icon: "fa-files-o",
        summary: "Save and retrieve data.  If you need to interface with an external data store, or have complex data requirements, you will need to write a custom extension (It's not difficult, I promise!)",
        methods: {
          save: {
            summary: "Save some data",
            params: [
              {
                name:        "collection",
                description: "Where to store the data."
              },
              {
                name:        "data OR key",
                description: "If a string or number, this will be the key and only data stored\nIf a hash, the set of values will be stored.  Some special keys:\n  key - A key, unique to the collection.  If none is given, one will be assigned.\n  label - description of the data.  Optional, but suggested.  If none given, the key will be used as the label.\n  image_id - If set, this will be used as the thumbnail"
              }
            ],
            returns: {
              name: "key",
              description: "The key to retrieve the data"
            }
          },
          find: {
            summary: "Find a single item",
            params: [
              {
                name:        "collection",
                description: "name of the collection"
              },
              {
                name: "criteria",
                description: "If a string, treat this as the key\nIf a hash, search on each key and value\nFor example: data.find('countries',{name:'United States'})\n\nYou can also specify a hash as a value, to search within an array of values\ndata.find_all('countries',{spoken_languages: { name: 'Spanish'}})"
              }
            ],
            returns: {
              name: "data item or null",
              description: "The queries item"
            }
          },
          find_all: {
            summary: "Find multiple or no items",
            params: [
              {
                name:        "collection",
                description: "name of the collection"
              },
              {
                name: "criteria",
                description: "If a string, treat this as the key\nIf a hash, search on each key and value\nFor example: data.find('countries',{name:'United States'})\n\nYou can also specify a hash as a value, to search within an array of values\ndata.find_all('countries',{spoken_languages: { name: 'Spanish'}})"
              }
            ],
            returns: {
              name: "array",
              description: "The queries items"
            }
          },
        }
      }
    end

    def initialize(trace=[])
      @trace = trace
    end

    def save(collection, data)
      DataContainer.save(collection, data)
    end
    
    def find(collection, criteria)
      DataContainer.find(collection, criteria)
    end

    def find_all(collection, criteria)
      DataContainer.find_all(collection, criteria)
    end
  end
end
