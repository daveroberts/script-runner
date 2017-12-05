require "sinatra"

# scripts_controller.rb
class App < Sinatra::Application

  get "/last_10_runs/:script_id/?" do
    return ScriptRun.last_n(params[:script_id], 10).to_json
  end

end
