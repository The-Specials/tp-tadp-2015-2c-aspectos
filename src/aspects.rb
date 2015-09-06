class Aspects
  @origen

  def self.origen
    return @origen
  end

  def self.on(*origenes)
    @origen=origenes
    raise ArgumentError if origenes.empty?
  end

end