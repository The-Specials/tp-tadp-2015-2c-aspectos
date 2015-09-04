class OrigenInvalido
  def getOrigenes
    nil
  end
end

class Object_Mock
  def getOrigenes
    self
  end
end

class Class_Mock
  def self.getOrigenes
    self
  end
end

module Module_Mock
  def self.getOrigenes
    self
  end
end

class Regex_Mock
  def getOrigenes
    [Module_Mock, Class_Mock]
  end
end