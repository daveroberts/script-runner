require 'securerandom'

module LocalStorage
  class Queue
    def self._icon
      "fa-database"
    end

    def initialize
    end

    # Add an item to the queue
    # item: something
    # options:
    #   force_type: nil, JSON, TEXT
    #   summary: something
    #   summary_type: something else
    #   thumbnail_key
    def self.add(item, options = {
      summary: nil,
      thumbnail_key: nil,
      summary_type: nil,
      force_item_type: nil,
    })
    end
  end
end
