# encoding: utf-8

module Origin

  def defined?
    self.regexp? ?
        Object.constants.any? { |c| c =~ self } :
        true
  end

  def result
    self.regexp? ?
        Object.constants.select { |c| c =~ self }.map { |c| eval(c.to_s) } :
        self
  end

  def regexp?
    self.instance_of? Regexp
  end

  def object_methods
    (self.is_a? Class or self.is_a? Module) ?
        self.instance_methods - Object.methods : self.is_a?(Regexp) ?
        self.result.map { |o| o.instance_methods - Object.methods } :
        self.singleton_class.instance_methods - Object.methods
  end

end

class Aspects

  def self.on(*origins, &block)
    raise ArgumentError, 'wrong number of arguments (0 for +1)' if origins.empty?
    raise ArgumentError, 'origen vacío' unless origins.any? { |o| o.defined? }
    @n_origins = origins.map {
      |o| o.result }.flatten.uniq.select {
      |o| o.object_methods }.flatten
    @f = :=~
    instance_eval(&block) if block_given?
  end

  def self.where(*conditions)
    conditions.map{ |c| c.call }.flatten.uniq
  end

  def self.name(arg, &block)
    lambda { @n_origins.map { |n| n.object_methods }.flatten.select { |m| arg.send(@f, m) } }
  end

  def self.neg(arg)
    @f = :!~
    arg
  end

  def self.transform(arg)
    arg
  end

end