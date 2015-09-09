require_relative 'Origen'
require_relative 'Transformacion'
require_relative 'Condicion'

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

  def self.fuentes
    @fuentes
  end

  def self.convertir_origenes(origenes)
    origenes.map{|orig| orig.get_match(@fuentes)}.flatten
  end

  def self.on(*origenes)
    @origen = @fuentes.select{|fuente| (convertir_origenes origenes).include? fuente}
    raise ArgumentError, 'origen vacio' unless  @origen.any?
    end
  end
