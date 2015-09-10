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
      old_name = "__old_#{method.name.to_s}__".to_sym

      #method.owner.send(:alias_method, old_name, method.name)
      #method.owner.send(:define_method, method.name, proc{ |*args| instance_eval &extend_behavior; instance_eval(old_name, *args) } )
      method.owner.class_eval do
        alias_method old_name, method.name
        define_method method.name do |*args|
          instance_eval &extend_behavior
          instance_eval{__old_a_public_method__ *args}
        end
      end
    end
  end

  def after &extend_behavior
    lambda do |method|
      old_name = "__old_#{method.name.to_s}__".to_sym

      method.owner.send(:alias_method, old_name, method.name)
      method.owner.send(:define_method, method.name, proc{ |*args| send(old_name, *args); instance_eval &extend_behavior } )
    end
  end

  private
  def transform &behavior
    lambda do |method|
      method.owner.send(:define_method, method.name, &behavior )
    end
  end
end