require "sinatra"
require "./lib/simple-language-parser/executor.rb"

# scripts_controller.rb
class App < Sinatra::Application
  post "/run/?" do
    script = request.body.read
    executor = SimpleLanguage::Executor.new
    output = executor.run(script)
    return {
      status: "ok",
      script: script,
      output: output
    }.to_json
  end
end
