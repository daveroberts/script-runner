require "sinatra"
require 'json'

class App < Sinatra::Application

  before '/users/?*' do
    halt 401, {'Content-Type'=> 'text/plain'}, "Unauthorized" if !session[:user]
  end

  users = [
    {id: 1, name: "Dave", age: 34},
    {id: 2, name: "Jen", age: 35},
    {id: 3, name: "美菜", age: 18},
    {id: 4, name: "하준", age: 24},
    {id: 5, name: "عالي", age: 26}
  ]

  get "/users/?" do
    users.to_json
  end

  get "/users/:id/?" do |id|
    if !/^\d+$/.match(id)
      status 422
      body "Must pass in an integer"
      return
    end
    users.find{|u|u[:id]==id.to_i}.to_json
  end

  post "/users/?" do
    if !@request_json
      response.status = 422
      body "Invalid JSON"
      return
    end
    user = @request_json
    max_id = 0
    users.each do |u|
      max_id = u[:id] if u[:id] > max_id
    end
    user[:id] = max_id + 1
    users.push user
    user.to_json
  end

  put "/users/:id/?" do |id|
    if !/^\d+$/.match(id)
      status 422
      body "Must pass in an integer"
      return
    end
    if !@request_json
      response.status = 422
      body "Invalid JSON"
      return
    end
    new_user = @request_json
    user_index = users.find_index{|u|u[:id]==id.to_i}
    if !user_index
      status 404
      body "user not found"
      return
    end
    users[user_index] = users[user_index].merge(new_user)
    users[user_index].to_json
  end

  delete "/users/:id/?" do |id|
    if !/^\d+$/.match(id)
      status 422
      body "Must pass in an integer"
      return
    end
    user_index = users.find_index{|u|u[:id]==id.to_i}
    if !user_index
      status 404
      body "user not found"
      return
    end
    users.delete_at(user_index)
    body ""
  end
end
