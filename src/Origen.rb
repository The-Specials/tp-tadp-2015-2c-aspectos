module Origen
  def get_match(fuentes)
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

    def methods
      publicos = public_methods false
      privados = private_methods false
      publicos.concat(privados)
     end
  end

  class Regexp
  def get_match(fuentes)
   fuentes.select{|fuente| self.match(fuente.to_s)}
  end
end
