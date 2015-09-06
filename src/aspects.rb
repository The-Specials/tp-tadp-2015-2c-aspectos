# encoding: utf-8

module Origin

  def defined?
    self.regexp? ? Object.constants.any? { |c| c =~ self } : true
  end

  def result
    self.regexp? ? Object.constants.select { |c| c =~ self }.map { |c| eval(c.to_s) } : self
  end

  def name
  end

  def has_parameters(num, mode)
  end

  def regexp?
    self.instance_of? Regexp
  end

  def object_methods
    (self.is_a? Class or self.is_a? Module) ? self.instance_methods(false) :
       self.singleton_class.instance_methods - Object.methods
  end

end

class Aspects

  def self.on(*origins, &block)
    raise ArgumentError, 'wrong number of arguments (0 for +1)' if origins.empty?
    raise ArgumentError, 'origen vacío' unless origins.any? { |o| o.defined? }
    #origins.map{ |o| o.result }.flatten.uniq.map{ |o| o.object_methods }.flatten
    origins.map {
      |o| o.result }.flatten.uniq.select {
      |o| o }.map { 
      |o| o.object_methods }.flatten
  end

  def where(*conditions)
  end

  def neg
  end

  def transform
  end

end
