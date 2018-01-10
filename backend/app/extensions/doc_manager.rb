require 'securerandom'

module SimpleLanguage
  class DocManager
    def self._info
      {
        icon: "fa-files-o",
        summary: "Documents are a data structure which contain may fields with data.  Fields can hold text, images, or array of these items.  This extension allows the creation and reading of documents",
        methods: {
          create: {
            summary: "Create a new document",
            params: [
            ],
            returns: {
              name: "document",
              description: "A new document object"
            }
          },
          get: {
            summary: "Get an existing document",
            params: [
              { name:        "document_id",
                description: "id of the document you wish to retrieve" }
            ],
            returns: {
              name: "document",
              description: "The document object"
            }
          },
          remove: {
            summary: "Remove a document",
            params: [
              { name:        "document_id",
                description: "id of the document you wish to remove" }
            ],
            returns: {
              name: "int",
              description: "The number of documents removed"
            }
          },
        }
      }
    end

    def initialize(trace=[])
      @trace = trace
    end

    def create(values = {})
      Document.new({ id: nil, values: values })
    end
    
    def get(document_id)
      Document.get(document_id)
    end

    def remove(document_id)
    end
  end
end
