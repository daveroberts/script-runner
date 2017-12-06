require "sinatra"

# queue_controller.rb
class App < Sinatra::Application

  get "/queue/:name/items/?" do
    return QueueItem.by_queue_name(params[:name]).to_json
  end

end
