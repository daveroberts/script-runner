require "sinatra"

# data_controller.rb
class App < Sinatra::Application
  get "/tags/?" do
    return Tag.names.to_json
  end

  get "/tags/:name/?" do
    return DataItem.by_tag(params[:name]).to_json
  end

  get "/data_item/:key/?" do
    data_item = DataItem.find(params[:key])
    content_type 'text/plain', charset: 'utf-8'
    return [404, "data item not found"] if !data_item
    content_type data_item[:item_mime_type]
    if data_item[:item_mime_type] == 'application/json'
      return [200, data_item[:item].to_json]
    else
      return [200, data_item[:item]]
    end
  end

  get "/data_item_preview/:key/?" do
    data_item = DataItem.find(params[:key])
    content_type 'text/plain', charset: 'utf-8'
    return [404, "data item not found"] if !data_item
    content_type data_item[:preview_mime_type]
    if data_item[:preview_mime_type] == 'application/json'
      return [200, data_item[:preview].to_json]
    else
      return [200, data_item[:preview]]
    end
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

  get "/queue_item/:key/?" do
    item = QueueItem.by_item_key(params[:key])
    content_type 'text/plain', charset: 'utf-8'
    return [404, "item not found"] if !item
    content_type item[:item_mime_type]
    if item[:item_mime_type] == 'application/json'
      return [200, item[:item].to_json]
    else
      return [200, item[:item]]
    end
  end

end
