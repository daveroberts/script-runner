require "sinatra"

# traces_controller.rb
class App < Sinatra::Application
  get "/traces/:id/?" do
    return Script.get_traces(params[:id]).to_json
  end
end
