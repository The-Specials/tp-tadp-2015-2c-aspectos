require_relative 'with_conditions'

module OriginSource
  def get_origin
    self
  end
end

module Origin
  include WithConditions
  include OriginSource

  def origin_method_names
    instance_methods(true).concat(private_instance_methods(true))
  end

  def origin_methods
    origin_method_names.map { |name| origin_method name }
  end

  def origin_method name
    instance_method name
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
  include OriginSource

  def get_origin
    valid_constants = Object.constants.select{ |c| self.match(c) and Object.const_get(c).is_a? Module }
    valid_constants.map{ |c| Object.const_get(c) }
  end
end

class Array
  include OriginSource

  def get_origin
    raise ArgumentError, 'origen invalido' unless valid?

    /.*/.get_origin.select { | origin | origin.ancestors.includes? self }
  end

  def valid?
    size > 1 and count { | m | m.is_a? Class } < 2
  end

  def includes? other_array
    (other_array - self).empty?
  end
end