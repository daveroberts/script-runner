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
    code = request.body.read
    output = Script.run_code(code)
    return {
      status: "ok",
      code: code,
      output: output
    }.to_json
  end
end
