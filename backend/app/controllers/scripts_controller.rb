require "sinatra"

# scripts_controller.rb
class App < Sinatra::Application
  get "/scripts/?" do
    return Script.all.to_json
  end

  get "/scripts/:id/?" do
    return Script.find(params[:id]).to_json
  end

  post "/run/?" do
    script = request.body.read
    output = Script.run_adhoc(script)
    return {
      status: "ok",
      script: script,
      output: output
    }.to_json
  end
end
