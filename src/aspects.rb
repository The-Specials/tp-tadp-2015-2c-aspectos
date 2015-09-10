require_relative 'Origen'
require_relative 'Transformacion'
require_relative 'Condicion'

class Aspects

  @origen
  attr_reader :fuentes

  def self.origen
    return @origen
  end

  def self.set_origen(*origenes_nuevos)
    @origen = origenes_nuevos
  end

  def self.metodos
    @metodos
  end

  def initialize
    @origen= []
    @fuentes= []
    @metodos= []
  end

  def self.set_fuentes(*fuentes_nuevas)
    @fuentes = fuentes_nuevas
  end

  def self.fuentes
    @fuentes
  end


  def self.get_methods
     @origen.map{|orig| orig.methods}.flatten
  end


  def self.convertir_origenes(origenes)
    origenes.map{|orig| orig.get_match(@fuentes)}.flatten
  end

  def self.on(*origenes)
    @origen = @fuentes.select{|fuente| (convertir_origenes origenes).include? fuente}
    raise ArgumentError, 'origen vacio' unless  @origen.any?
  end

  def self.where(*condiciones)
    @metodos = @origen.each{|orig| orig.methods}.select{|metodo| metodo.satisfy{condiciones}}
  end
  end
