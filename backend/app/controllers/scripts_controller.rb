require "sinatra"

# scripts_controller.rb
class App < Sinatra::Application
  get "/scripts/?" do
    return Script.all.to_json
  end

  get "/scripts/:id/?" do
    return Script.find(params[:id]).to_json
  end

  post "/scripts/?" do
    script = JSON.parse(request.body.read, symbolize_names: true)
    begin
      Script.save(script)
      return { script: script }.to_json
    rescue InvalidScript => e
      return [400, e.error.to_json]
    rescue Exception => e
      return [500, e]
    end
  end

  post "/run/?" do
    script = JSON.parse(request.body.read, symbolize_names: true)
    arg = nil
    arg = JSON.parse(script[:input][:payload]) if script[:input][:send]
    output = Script.run_code(script[:code], arg)
    return {
      status: "ok",
      code: script[:code],
      output: output
    }.to_json
  end
end
