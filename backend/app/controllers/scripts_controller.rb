require "sinatra"

# scripts_controller.rb
class App < Sinatra::Application
  get "/scripts/?" do
    return Script.all.to_json
  end

  get "/scripts/:id/?" do
    return Script.find(params[:id]).to_json
  end

  get "/queue/:name/scripts/?" do
    return Script.for_queue(params[:name]).to_json
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
  
  post "/scripts/:id/set_default_input/?" do
    payload = request.body.read
    result = Script.set_default_input(params[:id], payload)
    return [200, "OK"]
  end

  post "/run/?" do
    payload = JSON.parse(request.body.read, symbolize_names: true)
    input = nil
    input = JSON.parse(payload[:input], symbolize_names: true) if payload[:input]
    script_run = Script.run_code(payload[:code], input, payload[:extensions], payload[:script_id])
    return script_run.to_json
  end
end
