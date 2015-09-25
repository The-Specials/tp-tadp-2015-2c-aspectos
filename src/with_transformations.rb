module WithTransformations

  def instead &new_definition
    owner.send(:define_method, name, new_definition)
  end

  def inject hash
    orig_method = self
    to_inject = parameters.map{ |param| hash[param[1]] }
    instead &proc { |*args| orig_method.bind(self).call *to_inject.combine(args) }
  end

  def redirect_to substitute
    sym = name
    instead &proc { |*args| substitute.send(sym, *args) }
  end

  def before &extend_behavior
    orig_method = self
    instead &proc { |*args| instance_eval &extend_behavior; instance_eval { orig_method.bind(self).call *args } }
  end

  def after &extend_behavior
    orig_method = self
    instead &proc { |*args| instance_eval { orig_method.bind(self).call *args }; instance_eval &extend_behavior }
  end
end

class UnboundMethod
  include WithTransformations
end

class Array
  def combine other_array
    zip(other_array).map{ |tuple| tuple[0].nil? ? tuple[1] : tuple[0]}
  end
end

