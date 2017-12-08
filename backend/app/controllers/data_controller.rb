require "sinatra"

# data_controller.rb
class App < Sinatra::Application
  get "/tags/?" do
    return Tag.names.to_json
  end

  get "/tags/:name/?" do
    return DataItem.by_tag(params[:name]).to_json
  end

  get "/sets/?" do
    return SetItem.names.to_json
  end

  get "/sets/:name/?" do
    return SetItem.by_name(params[:name]).to_json
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

  get "/queues/:name/?" do
    return QueueItem.by_queue_name(params[:name]).to_json
  end

end
