require_relative 'with_conditions'
require_relative 'with_transformations'

module Origin
  include WithConditions
  include WithTransformations

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
    origin_method = method(sym)
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