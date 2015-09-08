module Origen
  def matches_to_any(*fuentes)
    self if fuentes.include? self
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
  def matches_to_any(*fuentes)
   fuentes.select{|fuente| self.match(fuente.to_s)}
  end
end
