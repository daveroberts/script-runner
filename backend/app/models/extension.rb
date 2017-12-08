# manages extensions on disk
class Extension
  @extensions = nil

  def self.all
    return @extensions if @extensions
    @extensions = []
    Dir["./app/extensions/*.rb"].each do |filepath|
      match = /.*\/(.*)\.rb$/.match(filepath)
      next if !match
      filename = match[1]
      class_name = filename.split("_").collect(&:capitalize).join
      clazz = Object.const_get(class_name)
      o = clazz.new
      methods = clazz.instance_methods - Object.instance_methods
      methods = methods.sort
      @extensions.push({
        name: class_name,
        methods: methods
      })
    end
    @extensions = @extensions.sort_by{|e|e[:name]}
    return @extensions
  end

end
