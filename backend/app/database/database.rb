require 'mysql2'
require 'thread'
require './app/lib/config.rb'
require './app/lib/blank.rb'

# Connection handle to database
class DB
  def self.raw_connection
    config = Config.get[:database]
    Mysql2::Client.default_query_options.merge!(symbolize_keys: true, cast_booleans: true)
    return Mysql2::Client.new(host: config[:host], database: config[:database], username: config[:username], password: config[:password], sslverify: config[:ssl_pem].present?, sslca: config[:ssl_ca])
  end

  config = Config.get[:database]
  SIZE = config[:connection_limit]
  @available = Queue.new
  SIZE.times do
    @available.push(DB.raw_connection)
  end

  def self.use(&block)
    begin
      connection = @available.pop
      connection = raw_connection if !connection.ping
      block.call(connection)
    ensure
      @available.push(connection)
    end
  end
end
