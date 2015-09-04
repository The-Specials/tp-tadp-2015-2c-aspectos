module Origen
 def get_origenes
   self
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
end

class Regexp
  def get_origenes
    valid_constants = Object.constants.select{ |c| self.match(c) }
    valid_constants.map{ |c| Object.const_get(c) }
  end
end