require_relative 'with_conditions'

module Origin
  include WithConditions

  def get_origin
   self
  end

  def origin_method_names
    instance_methods(true).concat(private_instance_methods(true))
  end

  def origin_methods
    origin_method_names.map { |name| instance_method name }
  end

  def origin_method name
    origin_methods.detect{ |method| method.name.eql? name }
  end

  def transform methods, &block
    methods.each{ |method| method.instance_eval &block }
  end

  def call_unbound unbound_method, *args
    unbound_method.bind(self).call *args
  end
end

class Module
  include Origin
end

class Object
  include Origin

  def instance_methods all
    methods all
  end

  def private_instance_methods all
    private_methods all
  end

  def instance_method sym
    owner = singleton_class
    origin_method = method(sym).unbind
    origin_method.send :define_singleton_method, :owner, proc{ owner }

    return origin_method
  end
end

class Regexp
  def get_origin
    valid_constants = Object.constants.select{ |c| self.match(c) }
    valid_constants.map{ |c| Object.const_get(c) }
  end
end