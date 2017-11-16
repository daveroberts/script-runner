require 'sinatra'
require 'json'
require_relative './controllers/users_controller.rb'
require_relative './controllers/scripts_controller.rb'

class App < Sinatra::Application
  enable :sessions
  before do
    content_type 'application/json', charset: 'utf-8'
  end
  get '/hello' do
    ["Разходка в Докторската градина и наоколо", "Bonjour"].to_json
  end
end
