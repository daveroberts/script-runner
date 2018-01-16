require 'securerandom'

# manages data items in database
class DataContainer
  DATA_CONTAINER_COLUMNS = [:id, :collection_id, :collection, :name, :image_id, :created_at]
  DATA_VALUE_COLUMNS = [:id, :data_container_id, :key, :type, :array, :summary, :value, :linked_image_id, :linked_collection, :linked_collection_id, :linked_queue_name, :linked_tag, :novel, :filedata, :created_at]
  attr_reader :collection, :name
  def initialize(options = {
      id: nil,
      collection: nil,
      collection_id: nil,
      values: nil,
      name: nil,
      image_id: nil,
      created_at: nil
  })
    @values = {}
    set_all(options[:values])
    @id = options[:id] if options[:id]
    @collection_id = options[:collection_id] if options[:collection_id]
    @collection = options[:collection] if options[:collection]
    @name = options[:name] if options[:name]
    @image_id = options[:image_id] if options[:image_id]
    @created_at = options[:created_at] if options[:created_at]
    raise "Must specify a collection" if !@collection
  end

  def [](key)
    value = @values[key.to_s]
    value.extend Pusher
    value
  end

  def []=(key, value)
    set(key.to_s, value)
  end

  def save()
    @collection_id = SecureRandom.uuid if !@collection_id
    # Save or update the container
    if !@id
      @id = SecureRandom.uuid
      @created_at = Time.now
      @name = @id if !@name
      DataMapper.insert('data_containers', fields)
    else
      DataMapper.update('data_containers', fields)
    end
    @values.each do |key, value|
      #TODO: Save to separate fields
      next if key==:collection ||
              key==:collection_id ||
              key==:image_id ||
              key==:created_at
      # Get the existing value to compare, see if it needs to be saved
      sql = "
SELECT `id`, `value` FROM data_values WHERE data_container_id=? AND `key`=?
"
      data = DataMapper.raw_select(sql, [@id, key.to_s])
      if data.length == 0
        DataMapper.insert('data_values', {
          id: SecureRandom.uuid,
          data_container_id: @id,
          key: key.to_s,
          type: "string",
          array: false,
          summary: value,
          value: value,
          created_at: Time.now
        })
      else
        if data[0][:value] == value
          # ignore this for now
        else
          sql = "
UPDATE data_values SET value = ? WHERE `key` = ? AND data_container_id = ?
"
          DataMapper.raw_select(sql, [value, key.to_s, @id])
        end
      end
      # TODO: tombstone and insert
      # TODO: support for arrays
      # TODO: support for other data types
    end
    self
  end

  def to_json(opts = nil)
    {
      type: "DataContainer",
      id: @id,
      collection: @collection,
      collection_id: @collection_id,
      name: @name,
      image_id: @image_id,
      created_at: @created_at
    }.to_json(opts)
  end

  def self.save(collection, values)
    dc = DataContainer.new({collection: collection, values: values})
    dc.save
  end

  def self.find(collection, criteria)
    if criteria.class == String
      sql = "
SELECT
  dc.id as dc_id,
  dc.name as dc_name,
  dc.image_id as dc_image_id,
  dc.created_at as dc_created_at,
  dv.id as dv_id,
  dv.`key` as dv_key,
  dv.`type` as dv_type,
  dv.value as dv_value,
  dv.created_at as dv_created_at
FROM data_containers dc
  LEFT JOIN data_values dv ON dc.id = dv.data_container_id
WHERE
  dv.`key` = ?
"
      data = DataMapper.select(sql, {prefix: "dc", has_many: [
        { prefix: 'dc' }
      ]}, criteria)
      binding.pry
    else
      sql = "
SELECT
  dc.id as dc_id,
  dc.collection as dc_collection,
  dc.collection_id as dc_collection_id,
  dc.name as dc_name,
  dc.image_id as dc_image_id,
  dc.created_at as dc_created_at,
  dv.id as dv_id,
  dv.`key` as dv_key,
  dv.`type` as dv_type,
  dv.value as dv_value,
  dv.created_at as dv_created_at
FROM data_containers dc
  LEFT JOIN data_values dv ON dc.id = dv.data_container_id
  #{criteria.each_with_index.map{|c,i|"LEFT JOIN data_values d#{i} ON dc.id=d#{i}.data_container_id"}.join("\n")}
WHERE
  dc.collection = ? AND
  #{criteria.each_with_index.map{|(k,v),i|"d#{i}.`key`=? AND d#{i}.value=?"}.join(" AND \n")}
"
      data = DataMapper.select(sql, {prefix: 'dc', has_many: [
        { data_values: { prefix: 'dv' } }
      ] },[collection, criteria.to_a.flatten.map{|item|item.to_s}].flatten)
      return nil if data.length == 0
      raise "Multiple values found for find query.  (If intended, use find_all instead)" if data.length > 1
      data = data.first
      ret_value = DataContainer.new({
        id: data[:id],
        name: data[:name],
        image_id: data[:image_id],
        collection: data[:collection],
        collection_id: data[:collection_id],
        values: {},
        created_at: data[:created_at]
      })
      ret_value
    end
  end

  def self.find_all(collection, criteria)
    return [] if !$data.has_key?(collection)
    items = $data[collection].select do |item|
      criteria.each do |k,v|
        return false if item[k] != v
      end
      true
    end
    items
  end

  private
  
  def set_all(hash)
    return if !hash
    hash.each do |key, value|
      set(key, value)
    end
  end

  def set(key, value)
    if (key.to_s.casecmp("label")==0 ||
        key.to_s.casecmp("label")==0 ||
        key.to_s.casecmp("label")==0 ||
        key.to_s.casecmp("label")==0 ||
        key.to_s.casecmp("label")==0)
      @name = value 
    end
    @name = value if key.to_s.casecmp("name")==0
    @name = value if key.to_s.casecmp("title")==0
    @name = value if key.to_s.casecmp("subject")==0
    @name = value if key.to_s.casecmp("summary")==0
    @image_id = value if key.to_s.casecmp("image_id")==0
    @collection = value if key.to_s.casecmp("image_id")==0
    @values[key] = value
  end

  def fields
    return {
      id: @id,
      collection_id: @collection_id,
      collection: @collection,
      name: @name,
      image_id: @image_id,
      created_at: @created_at
    }
  end
end
