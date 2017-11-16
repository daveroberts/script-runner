require "sinatra"
require "./lib/simple-language-parser/executor.rb"

# scripts_controller.rb
class App < Sinatra::Application
  post "/run/?" do
    script = request.body.read
    executor = SimpleLanguage::Executor.new
    begin
      output = executor.run(script)
      return {
        status: "ok",
        script: script,
        output: output
      }.to_json
    rescue SimpleLanguage::UnknownCommand => e
      return [
        400, {
          status: "error",
          error: e.to_s
        }.to_json
      ]
    end
  end
end
