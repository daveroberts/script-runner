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
      method_names = clazz.instance_methods - Object.instance_methods
      method_names = method_names.sort
      methods = {}
      method_names.each do |method|
        params = clazz.instance_method(method).parameters.map{|p|p[1]}
        methods[method] = {
          summary: "",
          params: params.map{|p|{name: p, description: ""}},
          returns: nil
        }
      end
      @extensions[class_name] = {
        icon: 'fa-code',
        summary: "",
        methods: methods
      }
      if clazz.respond_to? :_info
        info = clazz._info
        info.each do |prop,value|
          @extensions[class_name][prop] = value
        end
      end
    end
    return @extensions
  end

end
