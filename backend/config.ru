require "./app/app.rb"
if ENV["RACK_ENV"]=='development'
  require 'pry'
end

use Rack::Deflater

# redefining root throws warning.  Set to TOML gem library?
#::ROOT = File.dirname( File.expand_path( __FILE__ ) )
urlmap = { "/api"=> App.new }
if ENV["RACK_ENV"]=='production'
  use Rack::Static, urls: { "/"=> "index.html" }, root: "dist"
  urlmap["/"] = Rack::Directory.new("dist")
end
run Rack::URLMap.new(urlmap)
