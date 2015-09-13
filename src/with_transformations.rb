module WithTransformations

  def transform methods, &block
    instance_eval &block
    methods.each{ |method| transformations.each{ |transformation| transformation.call(method) } }
  end

  def transformations
    @transformations
  end

  def public_initialize
    @transformations = Array.new
  end

  def redirect_to substitute
    @transformations << lambda{ |method| method.owner.send(:define_method, method.name, proc{ |*args| substitute.send(method.name, *args) }) }
    @transformations[-1]
  end

  def instead &new_behavior
    @transformations << lambda{ |method| method.owner.send(:define_method, method.name, new_behavior) }
    @transformations[-1]
  end

  def before &extend_behavior
    @transformations << lambda do |method|
      orig_method = method.owner.instance_method method.name
      method.owner.send(:define_method, method.name, proc{ |*args| instance_eval &extend_behavior; instance_eval{ orig_method.bind(self).call *args } })
    end
    @transformations[-1]
  end

  def after &extend_behavior
    @transformations << lambda do |method|
      orig_method = method.owner.instance_method method.name
      method.owner.send(:define_method, method.name, proc{ |*args| instance_eval{ orig_method.bind(self).call *args }; instance_eval &extend_behavior })
    end
    @transformations[-1]
  end
end