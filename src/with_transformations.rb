module WithTransformations

  def instead &new_definition
    owner.send(:define_method, name, new_definition)
  end

  def inject hash
    sym = name
    orig_method = self
    to_inject = arguments.map{ |arg| hash[arg] }
    instead &(
      proc do |*args|
        injected_args = to_inject.combine(args) {|new, old| new.injected_value self, sym, old}
        call_unbound orig_method, *injected_args
      end)
  end

  def redirect_to substitute
    sym = name
    instead &proc { |*args| substitute.send(sym, *args) }
  end

  def before &extend_behavior
    orig_method = self
    instead &proc { |*args| instance_eval &extend_behavior; instance_eval { call_unbound orig_method, *args } }
  end

  def after &extend_behavior
    orig_method = self
    instead &proc { |*args| instance_eval { call_unbound orig_method, *args }; instance_eval &extend_behavior }
  end
end

class UnboundMethod
  include WithTransformations

  def arguments
    parameters.map{ |param| param[1] }
  end
end

class Array
  def combine other_array, &block
    zip(other_array).map{ |tuple| tuple[0].nil? ? tuple[1] : block.call(tuple[0], tuple[1]) }
  end
end

class Object
  def injected_value *args
    self
  end
end

class Proc
  def injected_value *args
    self.call *args
  end
end
