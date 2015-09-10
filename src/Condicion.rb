module Condicion

  def name(regex)
    get_methods.select{|metodo| regex.match(metodo.to_s)}
  end

  def has_parameters

  end

  def is_public

  end

  def is_private

  end

  def neg

  end
end

class Class
  include Condicion
end