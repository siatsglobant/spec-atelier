class Presenter
  class << self
    def will_print(*args)
      @will_print = args
    end

    def decorate(model)
      @resource = model
      define_obj_response
    end

    def decorate_list(list)
      list.map {|resource| decorate(resource) }
    end

    def presenter_inheritor_method_response(key)
      presenter_inheritor.send(key) rescue nil
    end

    def resource_or_presenter_inheritor_response(key)
      presenter_inheritor_method_response(key) || @resource.send(key)
    end

    def presenter_inheritor
      @presenter_inheritor ||= new(@resource)
    end

    def reload_presenter_inheritor
      @presenter_inheritor = nil
    end

    def define_obj_response
      presenter_inheritor.tap {|object| @will_print.each {|key| instance_variables(object, key) } }
    end

    def instance_variables(presenter_obj, key)
      value = resource_or_presenter_inheritor_response(key)
      presenter_obj.instance_variable_set("@#{key}", value)
      reload_presenter_inheritor if @will_print.last == key
    end
  end

  def initialize(subject = nil)
    define_singleton_method(subject.class.to_s.downcase) { subject } if subject
  end
end
