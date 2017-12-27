require 'securerandom'

module SimpleLanguage
  class Queue
    def self._icon
      "fa-database"
    end

    def initialize
    end

    # Add an item to the queue
    # item: BLOBABLE
    # options:
    #   summary: JSONABLE
    #   thumbnail_image_id
    def self.add(item, options = {
      summary: nil,
      thumbnail_image_id: nil,
    })
    end
  end
end
