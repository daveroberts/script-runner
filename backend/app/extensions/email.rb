require 'mailgun'

class Email
  def self.icon
    "fa-envelope"
  end

  def initialize
  end

  # Send an email
  def send_email(from, to, subject, text)
    config = Config.get[:email]
    mg_client = Mailgun::Client.new config[:api_key]
    message_params =  {
      from:     from,
      to:       to,
      subject:  subject,
      text:     text
    }
    mg_client.send_message config[:domain], message_params
    return true
  end

end
