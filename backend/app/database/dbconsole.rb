require './app/lib/config.rb'

config = Config.get[:database]
puts "mysql -u #{config[:username]} -p'#{config[:password]}' -h #{config[:host]} --database=#{config[:database]} --ssl-ca=#{config[:ssl_pem]?config[:ssl_pem]:''}"
