class Aspects

  def self.origins= origins
    @@origins = origins
  end

  def self.on source, *more_sources, &block
    sources = more_sources.unshift source
    @@origins = sources.map { |f| f.get_origin() }.flatten.compact.uniq

    raise ArgumentError, 'origen vacio' unless @@origins.any?

    @@origins.each{ |origin| origin.public_initialize; origin.instance_eval &block }

    return @@origins
  end
end

