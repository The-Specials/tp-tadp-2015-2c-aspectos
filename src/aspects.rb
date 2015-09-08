require_relative 'origin'
require_relative 'with_conditions'

class Aspects
  extend WithConditions

  def self.origins= origins
    @origins = origins
  end

  def self.on source, *more_sources
    sources = more_sources.unshift source
    @origins = sources.map { |f| f.get_origin() }.flatten.compact.uniq

    raise ArgumentError, 'origen vacio' unless @origins.any?

    return @origins
  end

  def self.where condition, *more_conditions
    conditions = more_conditions.unshift condition
    @origins.map{ |o| o.origin_methods }.flatten.select{ |method| satisfy_all?(method, conditions) }
  end

  private
  def self.satisfy_all?(method, conditions)
    conditions.all?{|condition| condition.call method}
  end
end

