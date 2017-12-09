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
      method_names = clazz.instance_methods - Object.instance_methods
      method_names = method_names.sort
      methods = {}
      method_names.each do |method|
        desc = ""
        comment = clazz.instance_method(method).comment
        #params = clazz.instance_method(method).parameters.map{|p|{required: p[0]==:req, name: p[1]}}
        params = clazz.instance_method(method).parameters.map{|p|p[1]}
        desc = comment[1..-1].strip if !comment.blank?
        methods[method] = {
          description: desc,
          params: params
        }
      end
      icon = clazz.respond_to?(:icon) ? clazz.icon : 'fa-code'
      @extensions.push({
        name: class_name,
        icon: icon,
        methods: methods
      })
    end
    @extensions = @extensions.sort_by{|e|e[:name]}
    return @extensions
  end

end
