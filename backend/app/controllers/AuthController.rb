require "sinatra"
require 'json'

class App < Sinatra::Application

  get "/session/?" do
    session[:user].to_json
  end

  post "/session/?" do
    user = @request_json
    if user[:password] == 'password' && user[:username]
      user.delete :password
      session[:user] = user
      session[:user].to_json
    else
      status 422
      body "Invalid password"
    end
  end

  delete "/session/?" do
    session[:user] = @request_json
    body ""
  end
end
