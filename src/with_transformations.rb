module WithTransformations

  def redirect_to substitute
    lambda do |method|
      method.owner.send(:define_method, method.name, proc{ |*args| substitute.send(method.name, *args) } )
    end
  end

  def instead &new_behavior
    lambda do |method|
      method.owner.send(:define_method, method.name, &new_behavior)
    end
  end

  def before &extend_behavior
    lambda do |method|
      orig_method = method.owner.instance_method method.name
      method.owner.send(:define_method, method.name,
        proc do |*args|
          instance_eval &extend_behavior
          instance_eval{ orig_method.bind(self).call *args }
        end)
    end
  end

  def after &extend_behavior
    lambda do |method|
      orig_method = method.owner.instance_method method.name
      method.owner.send(:define_method, method.name,
                        proc do |*args|
                          instance_eval{ orig_method.bind(self).call *args }
                          instance_eval &extend_behavior
                        end)
    end
  end

  private
  def transform &behavior
    lambda do |method|
      method.owner.send(:define_method, method.name, &behavior )
    end
  end
end