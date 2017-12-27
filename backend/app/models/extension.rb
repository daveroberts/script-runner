# manages extensions on disk
class Extension
  @extensions = nil

  def self.all
    return @extensions if @extensions
    @extensions = {}
    Dir["./app/extensions/**/*.rb"].each do |filepath|
      match = /^\.\/app\/extensions\/(.*)\.rb$/.match(filepath)
      next if !match
      class_name = match[1]
      class_name = class_name.split("_").collect(&:capitalize).join
      clazz = Object.const_get("SimpleLanguage::#{class_name}")
      o = clazz.new
      info = { icon: 'fa-code', summary: "No _info method found" }
      info = clazz._info if clazz.respond_to? :_info
      @extensions[class_name] = info
      method_names = clazz.instance_methods - Object.instance_methods
      method_names = method_names.sort
      method_params = {}
      method_names.each do |method|
        params = clazz.instance_method(method).parameters.map{|p|p[1]}
        method_params[method] = params
      end
      @extensions[class_name][:params] = method_params
    end
    return @extensions
  end

end
