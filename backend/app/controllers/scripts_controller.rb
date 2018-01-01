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
    body = request.body.read
    package = JSON.parse(body, symbolize_names: true)
    result = Script.set_default_input(params[:id], package[:payload], package[:mime_type])
    return [200, "OK"]
  end

  get "/http/:endpoint/?" do
    #todo update with trace ID and encoding options
    script = Script.find_by_http_endpoint(params[:endpoint], 'GET')
    return [404, "No script found for that trigger"] if !script
    script_run = Script.run_code(script[:code], nil, script[:id], script[:triggers][0][:id])
    return script_run[:output].to_json
  end

  post "/http/:endpoint/?" do
    #todo update with trace ID and encoding options
    input = nil
    body = request.body.read
    input = body if !body.blank?
    input = JSON.parse(body, symbolize_names: true) if !body.blank? && request.env["CONTENT_TYPE"] == 'application/json'
    script = Script.find_by_http_endpoint(params[:endpoint], 'POST')
    return [404, "No script found for that trigger"] if !script
    script_run = Script.run_code(script[:code], input, script[:id], script[:triggers][0][:id])
    return script_run[:output].to_json
  end

  post "/run/?" do
    payload = JSON.parse(request.body.read, symbolize_names: true)
    input = nil
    input = JSON.parse(payload[:input], symbolize_names: true) if !payload[:input].blank?
    script_run = Script.run_code(payload[:code], input, payload[:trace_id], payload[:script_id])
    return script_run.to_json
  end
end
