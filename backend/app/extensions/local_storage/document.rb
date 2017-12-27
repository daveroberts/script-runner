require 'securerandom'

module LocalStorage
  class Document
    def self._icon
      "fa-database"
    end

    def initialize(document_id=nil)
    end

    def self.get(document_id)
    end

    def set(key, value, options = {
      tags: [],
      tag: nil,
      summary: nil,
      summary_type: nil,
      thumbnail_key: nil,
      force_value_type: nil,
    })
    end
  end
end
