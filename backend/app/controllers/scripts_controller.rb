require "sinatra"
require "./lib/simple-language-parser/executor.rb"

# scripts_controller.rb
class App < Sinatra::Application
  get "/scripts/?" do
    return Script.all.to_json
  end

  post "/run/?" do
    script = request.body.read
    output = Script.run_ad_hoc(script)
    return {
      status: "ok",
      script: script,
      output: output
    }.to_json
  end
end
