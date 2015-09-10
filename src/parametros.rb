class NilClass
  def satisfies(metodo, num_param)
    abs(method(metodo).arity).eql? num_param
  end



end