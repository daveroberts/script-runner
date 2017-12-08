require "sinatra"

# extensions_controller.rb
class App < Sinatra::Application
  get "/extensions/?" do
    return Extension.all.to_json
  end
end
