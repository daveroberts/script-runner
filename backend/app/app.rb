require 'sinatra'
require 'json'
require_relative './controllers/UsersController.rb'
require_relative './controllers/AuthController.rb'

class App < Sinatra::Application
  enable :sessions
  before do
    content_type 'application/json', charset: 'utf-8'
    request.body.rewind
    body = request.body.read
    begin
      @request_json = JSON.parse(body, symbolize_names: true)
    rescue JSON::ParserError
      # @request_json just won't be set
    end
  end
  get '/hello' do
    ["Разходка в Докторската градина и наоколо", "Bonjour"].to_json
  end
end
