require 'sinatra'
require 'json'
Dir['./app/controllers/*.rb'].each { |file| require file }
Dir['./app/lib/*.rb'].each { |file| require file }
Dir['./app/models/*.rb'].each { |file| require file }
Dir['./app/extensions/**/*.rb'].each { |file| require file }

class App < Sinatra::Application
  enable :sessions
  before do
    content_type 'application/json', charset: 'utf-8'
  end
  get '/hello' do
    ["Разходка в Докторската градина и наоколо", "Bonjour"].to_json
  end
end
