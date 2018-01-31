module Query::BuilderMethods
  def __builder
    Builder(self).new
  end

  def count : Int64
    __builder.count
  end

  def where(**match_data) : Builder
    __builder.where **match_data
  end

  def first : self
    __builder.first
  end

  def first(n : Int32) : Array(self)
    __builder.first n
  end
end
