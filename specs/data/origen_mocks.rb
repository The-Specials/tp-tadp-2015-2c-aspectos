class OrigenInvalido
  def get_origenes
    nil
  end
end

class ObjectMock
  def get_origenes
    self
  end
end

class ClassMock
  def self.get_origenes
    self
  end
end

module ModuleMock
  def self.get_origenes
    self
  end
end

class RegexMock
  def get_origenes
    [ModuleMock, ClassMock]
  end
end