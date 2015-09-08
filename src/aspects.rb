require_relative 'Origen'

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
    @origen = origenes.each{|orig| orig.matches_to_any(@fuentes)}
    raise ArgumentError, 'origen vacío' if (origenes.empty? or @origen.empty?)
    end
  end
