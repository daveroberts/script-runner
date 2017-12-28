require 'securerandom'

module SimpleLanguage
  class Log
    def self._info
      {
        icon: "fa-pencil-square-o",
        summary: "Provides a way to log information",
        methods: {
          append: {
            summary: "Add to a log",
            params: [
             { name:         "log_name",
               description:  "Name of the log" },
             { name:         "text",
               description:  "text data to add to the log" },
             { name:         "level",
               description:  "Optional.  Log level.  Can be info | warn | error | fatal | debug.  Default level is info" },
            ],
            returns: nil
          },
        },
      }
    end

    def append(log_name, text, level='info')
    end
  end
end
