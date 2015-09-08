module Origen
  def get_origenes
   self
  end

  def origin_method_names
    instance_methods(true).concat(private_instance_methods(true))
  end

  def origin_methods
    origin_method_names.map { |name| instance_method name }
  end
end

class Class
  include Origen
end

class Module
  include Origen
end

class Object
  include Origen

  def origin_method_names
    singleton_class.instance_methods(true).concat(singleton_class.private_instance_methods(true))
  end

  def origin_methods
    origin_method_names.map { |name| method name }
  end
end

class Regexp
  def get_origenes
    valid_constants = Object.constants.select{ |c| self.match(c) }
    valid_constants.map{ |c| Object.const_get(c) }
  end
end