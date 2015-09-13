class Aspects
  def self.on source, *more_sources, &block
    sources = more_sources.unshift source
    origins = sources.map { |f| f.get_origin() }.flatten.uniq

    raise ArgumentError, 'origen vacio' if origins.empty?

    origins.each{ |origin| origin.public_initialize; origin.instance_eval &block }

    return origins
  end
end

