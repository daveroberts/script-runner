require 'mailgun'

module SimpleLanguage
  class Email
    def self._info
      {
        icon: "fa-envelope",
        summary: "Provides a way to send email",
        methods: {
          send: {
            summary: "Send an email",
            params: [
              { name:        "to",
                description: "Either a string with an email address, or an array of email addresses" },
              { name:        "subject",
                description: "Subject of email" },
              { name:        "body",
                description: "Body of email" },
              { name:        "from",
                description: "Optional.  Email address sending the email.  Must match the email providers domain.  defaults to default_sender from your config" },
            ],
            returns: {
              name: "boolean",
              description: "true if email has been queued to be sent.  May not send immediately"
            }
          },
        }
      }
    end

    def initialize(trace=[])
      @trace = trace
    end

    def send(to, subject, body, from=nil)
      config = Config.get[:email]
      mg_client = Mailgun::Client.new config[:api_key]
      message_params =  {
        from:     from||config[:default_sender],
        to:       to,
        subject:  subject,
        text:     body
      }
      mg_client.send_message config[:domain], message_params
      return true
    end
  end
end
