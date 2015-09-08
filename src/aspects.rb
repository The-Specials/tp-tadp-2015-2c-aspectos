class Aspects
  @origen
  attr_reader :fuentes

  def self.origen
    return @origen
  end

  def initialize
    @origen = []
    @fuentes =[]
  end

  def self.set_fuentes(*fuentes_nuevas)
    @fuentes = fuentes_nuevas
  end

  def self.on(*origenes)
    @origen = origenes.select {|orig| @fuentes.include? orig}
    raise ArgumentError, 'origen vacío' if (origenes.empty? or @origen.empty?)
    end
  end
