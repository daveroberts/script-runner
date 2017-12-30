require "sinatra"

# images_controller.rb
class App < Sinatra::Application
  get "/images/:id/thumbnail/?" do
    data = ImageItem.get_thumbnail(params[:id])
    content_type "image/png"
    return data
  end

  get "/images/:id/?" do
    data = ImageItem.get(params[:id])
    content_type "image/png"
    return data
  end
end
