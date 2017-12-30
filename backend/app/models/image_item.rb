require 'mini_magick'

class ImageItem
  #thumb = MiniMagick::Image.read(db_item)
  #thumb.resize "350x350"
  #data_item_fields[:preview] = thumb.to_blob
  #data_item_fields[:preview_mime_type] = thumb.mime_type
  
  def self.save(data, summary)
    image = MiniMagick::Image.read(data)
    id = SecureRandom.uuid
    fields = {
      id: id,
      data: data,
      summary: summary,
      full_image_id: nil,
      x_resolution: image.dimensions[0],
      y_resolution: image.dimensions[1],
      created_at: Time.now
    }
    result = DataMapper.insert("images", fields)
    return 0 if result == 0
    create_thumbnail(data, id, summary)
    id
  end

  def self.get(image_id)
    sql = "SELECT data FROM images WHERE id = ?"
    data = DataMapper.raw_select(sql, image_id)
    return nil if data.length == 0
    return data[0][:data]
  end

  def self.get_thumbnail(image_id)
    sql = "SELECT data FROM images WHERE full_image_id = ?"
    data = DataMapper.raw_select(sql, image_id)
    return nil if data.length == 0
    return data[0][:data]
  end

  def self.remove(image_id)
  end

  private

  def self.create_thumbnail(data, full_image_id, summary)
    image = MiniMagick::Image.read(data)
    image.resize "350x350"
    thumb_data = image.to_blob
    fields = {
      id: SecureRandom.uuid,
      data: thumb_data,
      summary: summary,
      full_image_id: full_image_id,
      x_resolution: 350,
      y_resolution: 350,
      created_at: Time.now
    }
    result = DataMapper.insert("images", fields)
  end
end
