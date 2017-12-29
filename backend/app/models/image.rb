class Image
  #thumb = MiniMagick::Image.read(db_item)
  #thumb.resize "350x350"
  #data_item_fields[:preview] = thumb.to_blob
  #data_item_fields[:preview_mime_type] = thumb.mime_type
end
