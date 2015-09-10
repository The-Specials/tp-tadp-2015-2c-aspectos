class MockClass
  attr_accessor :aux

  def a_public_method(a = 10, b=12, c)
    @aux = (@aux || a) + b + c
  end

  def another_method
  end

  private
  def a_private_method
  end

  def another_private_method(a=1, b)
  end
end

module MockModule
  def a_module_method(a = 10, b=12, c)
  end

  def another_method
    'Im from MockModule'
  end

  private
  def a_private_method(a)
  end
end

class AnotherMockedClass
  include MockModule
  attr_accessor :aux

  def a_public_method(a, b = 'AnotherMockedClass')
    @aux = 'Im ' + (@aux || a) + ' from ' + b
  end
end