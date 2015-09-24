module WithConditions

  def where condition, *more_conditions
    conditions = more_conditions.unshift condition
    origin_methods.select{ |method| satisfy_all?(method, conditions) }
  end

  def names regex
    lambda{|method| regex.match(method.name) }
  end

  def is_private
    lambda{|method| method.owner.private_instance_methods.include? method.name }
  end

  def is_public
    lambda{|method| method.owner.public_instance_methods.include? method.name }
  end

  def has_parameters(number, block_type = lambda{|arg| true})
    if block_type.is_a?(Regexp)
      regex = block_type
      block_type = lambda{|arg| regex.match arg[1]}
    end
    lambda{|method| method.parameters.count(&block_type) == number}
  end

  def neg(condition, *more_conditions)
    conditions = more_conditions.unshift condition
    lambda{|method| not conditions.any? {|condition| condition.call(method)}}
  end

  private
  def satisfy_all?(method, conditions)
    conditions.all?{|condition| condition.call method}
  end

  def mandatory
    lambda{|arg| arg[0] == :req}
  end

  def optional
    lambda{|arg| arg[0] == :opt}
  end
end