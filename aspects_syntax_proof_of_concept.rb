class AspectsConcept

  def self.on(&block)
    instance_eval(&block) if block
  end

  def self.transform array
    puts array
  end

  def self.where param, *restParams
    restParams.unshift param
    restParams.map { |param| param.call }
  end

  def self.name x
    lambda { x }
  end

end

#main
AspectsConcept.on do
  transform(where name('Asi se puede lograr'), name('la sintaxis solicitada'), name('para las transformaciones y condiciones.'))
end