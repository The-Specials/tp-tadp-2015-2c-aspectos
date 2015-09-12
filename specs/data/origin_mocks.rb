class OrigenInvalido
  def get_origin
    nil
  end
end

class ObjectMock
  def get_origin
    self
  end
end

class ClassMock
  def self.get_origin
    self
  end
end

module ModuleMock
  def self.get_origin
    self
  end
end

class RegexMock
  def get_origin
    [ModuleMock, ClassMock]
  end
end