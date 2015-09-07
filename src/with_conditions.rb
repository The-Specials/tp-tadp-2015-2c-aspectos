module WithConditions
  def name regex
    lambda{|metodo| regex.match(metodo.name) }
  end

  def is_private
    lambda{|metodo| metodo.owner.private_instance_methods.include? metodo.name }
  end

  def is_public
    lambda{|metodo| metodo.owner.public_instance_methods.include? metodo.name }
  end

  def has_parameters(number, block_type = lambda{|arg| true})
    lambda{|metodo| metodo.parameters.count(&block_type) == number}
  end

  def mandatory
    lambda{|arg| arg[0] == :req}
  end

  def optional
    lambda{|arg| arg[0] == :opt}
  end

  def neg(condition, *more_conditions)
    more_conditions.unshift condition
    lambda{|method| not more_conditions.any? {|condition| condition.call(method)}}
  end
end