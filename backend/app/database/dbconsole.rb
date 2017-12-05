require './app/lib/config.rb'

config = Config.get[:database]
puts "mysql -u #{config[:username]} -p'#{config[:password]}' -h #{config[:host]} --database=#{config[:database]} #{config[:ssl_pem]?"--ssl-ca=#{config[:ssl_pem]}":''}"
