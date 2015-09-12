class AClass
  def aux= value
    @aux = value
  end

  def a_public_method(a = 10, b=12, c)
    @aux = (@aux || a) + b + c
  end

  def another_method
    @aux
  end

  private
  def a_private_method
  end

  def another_private_method(a=1, b)
  end
end

module AModule
  def a_module_method(a = 10, b=12, c)
    @aux = (@aux || a) * b * c
  end

  def another_method
    'Im from MockModule'
  end

  private
  def a_private_method(a)
  end
end

class AnotherClass
  include AModule

  def a_public_method(a, b = 'AnotherMockedClass')
    @aux = 'Im ' + (@aux || a) + ' from ' + b
  end
end