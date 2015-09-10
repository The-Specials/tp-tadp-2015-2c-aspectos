module Condicion

  def name(regex)
    get_methods.select{|metodo| regex.match(metodo.to_s)}
  end

  def has_parameters(num_param, *tipo)
    get_methods.select{|metodo| method.parameters.count{|parametro| parametro.is(tipo)}}
  end

  def is_public
    lambda{ |metodo| public_method(metodo.to_s)}

  end

  def is_private
    lambda {|metodo| private_methods.include? metodo.to_s}
  end

  def neg(&block)
    lambda {|metodo| metodo.not block}

  end

  def mandatory
    lambda {|num_param, metodo| (method(metodo).arity).eql? num_param}
  end

  def optional
    lambda { |num_param, metodo| (method(metodo).arity).eql? -num_param}

  end
end

class Class
  include Condicion
end