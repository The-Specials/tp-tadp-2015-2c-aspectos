require_relative 'origen'
require_relative 'with_conditions'

class Aspects
  extend WithConditions

  def self.origenes= origins
    @origenes = origins
  end

  def self.on fuente, *mas_fuentes
    fuentes = mas_fuentes.unshift fuente
    @origenes = fuentes.map { |f| f.get_origenes() }.flatten.compact.uniq

    raise ArgumentError, 'origen vacio' unless @origenes.any?

    return @origenes
  end

  def self.where condition, *more_conditions
    conditions = more_conditions.unshift condition
    @origenes.map{ |o| o.origin_methods }.flatten.select{ |method| satisfy_all(method, conditions) }
  end

  private
  def self.satisfy_all(method, conditions)
    conditions.all?{|condition| condition.call method}
  end
end

