class OrigenInvalido
  def get_origenes
    nil
  end
end

class Object_Mock
  def get_origenes
    self
  end
end

class Class_Mock
  def self.get_origenes
    self
  end
end

module Module_Mock
  def self.get_origenes
    self
  end
end

class Regex_Mock
  def get_origenes
    [Module_Mock, Class_Mock]
  end
end