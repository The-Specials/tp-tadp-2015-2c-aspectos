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

class Class
  include Origin
end

class Module
  include Origin
end

class Object
  include Origin

  def origin_method_names
    methods(true).concat(private_methods(true))
  end

  def origin_methods
    origin_method_names.map { |name| get_origin_method(name, self.singleton_class) }
  end

  private
  def get_origin_method method, owner
    origin_method = method(method)
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

#opcion para evitar efecto sobre el metodo en origin_methods
# class OriginMethod < UnboundMethod
#   def initialize original_method, eigen_class
#     @method = original_method
#     @eigen_class = eigen_class
#   end
#
#   def owner
#     @eigen_class
#   end
#
#   def method_missing invoked_method, *args
#     @method.send invoked_method, *args
#   end
# end