require "sinatra"

# extensions_controller.rb
class App < Sinatra::Application
  get "/extensions/?" do
    extensions = Extension.all.sort.to_h
    return extensions.to_json
  end
end
