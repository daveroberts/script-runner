require 'securerandom'

module SimpleLanguage
  class Queue
    def self._info
      {
        icon: "fa-list",
        summary: "Add data items to a queue to be picked up and proccessed by another script",
        methods: {
          add: {
            summary: "Add an item to a queue to be picked up and processed by another script",
            params: [
              { name:        "queue_name",
                description: "queue item will be placed on" },
              { name:        "item",
                description: "any blobable item" },
              { name:        "options",
                description: "optional hash of values\nsummary - 'a short description of the item'\nimage_id - 'Used to show preview image'" }
            ],
            returns: {
              name: "int",
              description: "1 if item queued, 0 if not"
            }
          },
          next: {
            summary: "Pull the next item off of the queue and locks it for processing.  Note: Item should be processed or failed",
            params: [
              { name:        "queue_name",
                description: "retrieve item from this queue" },
            ],
            returns: {
              name: "container or null",
              description: "null if queue is empty, container = { id: 'id to process or fail', item: 'item from queue', summary: '', image_id: ''}"
            }
          },
          process: {
            summary: "Mark a queue item as processed",
            params: [
              { name:        "queue_item_id",
                description: "retrieved with next" },
            ],
            returns: {
              name: "int",
              description: "1 if marked, 0 if not"
            }
          },
          fail: {
            summary: "Mark a queue item as failed",
            params: [
              { name:        "queue_item_id",
                description: "retrieved with next" },
            ],
            returns: {
              name: "int",
              description: "1 if marked, 0 if not"
            }
          },
        }
      }
    end

    def initialize(trace)
      @trace = trace
    end

    def add(queue_name, item, options = {
      summary: nil,
      image_id: nil,
    })
      summary = options[:summary]
      summary = item if !summary
      @trace.push({ summary: "Adding #{summary} to queue `#{queue_name}`", level: :info, timestamp: Time.now })
      QueueItem.add(queue_name, item, options)
    end

    def next(queue_name)
      QueueItem.next(queue_name)
    end

    def process(queue_item_id)
    end

    def fail(queue_item_id)
    end
  end
end
