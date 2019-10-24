class Presenter
  class << self
    def will_print(*args)
      @will_print = args
    end

    def to_print(model)
      @resource = model
      define_obj_response
    end

    def presenter_inheritor_method_response(key)
      presenter_inheritor.send(key) rescue nil
    end

    def presenter_inheritor
      @presenter_inheritor ||= new(@resource)
    end

    def resource_or_presenter_inheritor_response(key)
      presenter_inheritor_method_response(key) || @resource.send(key)
    end

    def define_obj_response
      new.tap {|presenter_obj| @will_print.each {|key| instance_variables_and_methods(presenter_obj, key) } }
    end

    def instance_variables_and_methods(presenter_obj, key)
      value = resource_or_presenter_inheritor_response(key)
      presenter_obj.instance_variable_set("@#{key}", value)
      define_method(key) { value }
    end
  end

  def initialize(subject = nil)
    define_singleton_method(subject.class.to_s.downcase) { subject } if subject
  end
end
