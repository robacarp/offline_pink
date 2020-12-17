module JsonHelpers
  macro any(thing)
    JSON::Any.new({{ thing }})
  end

  macro blank_any
    JSON::Any.new({} of String => JSON::Any)
  end

  def to_any : JSON::Any
    blank_any
  end
end
