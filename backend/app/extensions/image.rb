require 'securerandom'

module SimpleLanguage
  class Image
    def self._info
      {
        icon: "fa-picture-o",
        summary: "Provides a way to store and retrieve images",
        methods: {
          save: {
            summary: "Save an image",
            params: [
             { name:         "data",
               description:  "Raw data for the image" },
             { name:         "summary",
               description:  "Description of the image" },
            ],
            returns: {
              name: "int",
              description: "The image id"
            }
          },
          get: {
            summary: "Get image data",
            params: [
               { name:        "image_id",
                 description: "id of the image" },
            ],
            returns: {
              name: "data or null",
              description: "raw image data"
            }
          },
          remove: {
            summary: "Remove image",
            params: [
               { name:        "image_id",
                 description: "id of the image" },
            ],
            returns: {
              name: "int",
              description: "1 if removed, 0 if no image by that id"
            }
          },
        },
      }
    end

    def initialize(trace=[])
      @trace = trace
    end

    def save(data, summary)
      ImageItem.save(data, summary)
    end

    def get(image_id)
    end

    def remove(image_id)
    end
  end
end
