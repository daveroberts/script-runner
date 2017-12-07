require "sinatra"

# data_controller.rb
class App < Sinatra::Application
  get "/tags/?" do
    return Tag.names.to_json
  end

  get "/sets/?" do
    return SetItem.names.to_json
  end

  get "/dictionaries/?" do
    return DictionaryItem.names.to_json
  end

  get "/dictionaries/:name/?" do
    return DictionaryItem.values(params[:name]).to_json
  end

  get "/queues/?" do
    return QueueItem.names.to_json
  end

end
