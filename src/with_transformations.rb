module WithTransformations

  def redirect_to substitute
    lambda{ |method| transform method, proc{ |*args| substitute.send(method.name, *args) } }
  end

  def instead &new_behavior
    lambda{ |method| transform method, new_behavior }
  end

  def before &extend_behavior
    lambda do |method|
      orig_method = method.owner.instance_method method.name
      transform method, proc{ |*args| instance_eval &extend_behavior; instance_eval{ orig_method.bind(self).call *args } }
    end
  end

  def after &extend_behavior
    lambda do |method|
      orig_method = method.owner.instance_method method.name
      transform method, proc{ |*args| instance_eval{ orig_method.bind(self).call *args }; instance_eval &extend_behavior }
    end
  end

  private
  def transform method, behavior
    method.owner.send(:define_method, method.name, behavior)
  end
end