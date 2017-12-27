# manages extensions on disk
class Extension
  @extensions = nil

  def self.all
    return @extensions if @extensions
    @extensions = {}
    Dir["./app/extensions/**/*.rb"].each do |filepath|
      match = /^\.\/app\/extensions\/(?:(.*)\/)?(.*)\.rb$/.match(filepath)
      next if !match
      module_name = match[1]
      class_name = match[2]
      module_name = module_name.split("_").collect(&:capitalize).join if module_name
      class_name = class_name.split("_").collect(&:capitalize).join
      full_name = class_name
      full_name = "#{module_name}::#{class_name}" if module_name
      clazz = Object.const_get(full_name)
      o = clazz.new
      class_method_names = clazz.methods - Object.methods
      class_method_names = class_method_names.sort
      class_methods = {}
      class_method_names.each do |method|
        next if method.to_s.start_with? "_"
        comment = clazz.method(method).comment
        begin
        comment = JSON.parse(comment.strip.split("\n").map{|c|c[1..-1]}.join, symbolize_names: true)
        rescue
          comment = {}
        end
        params = clazz.method(method).parameters.map{|p|p[1]}
        class_methods[method] = {
          doc: comment,
          summary: comment[:summary] || comment,
          params: params
        }
      end
      instance_method_names = clazz.instance_methods - Object.instance_methods
      instance_method_names = instance_method_names.sort
      instance_methods = {}
      instance_method_names.each do |method|
        comment = clazz.instance_method(method).comment
        comment = comment.strip.split("\n").map{|c|c[1..-1]}.join("\n")
        params = clazz.instance_method(method).parameters.map{|p|p[1]}
        instance_methods[method] = {
          doc: comment,
          params: params
        }
      end
      icon = clazz.respond_to?(:icon) ? clazz.icon : 'fa-code'
      @extensions[module_name||"_none_"] = {} if !@extensions.has_key? module_name||"_none_"
      @extensions[module_name||"_none_"][class_name] = {
        icon: icon,
        instance_methods: instance_methods,
        class_methods: class_methods,
      }
    end
    return @extensions
  end

end
