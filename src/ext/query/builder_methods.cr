module Query::BuilderMethods
  def __builder
    Builder.new(self)
  end

  def count : Int32
    __builder.count
  end

  def where(**match_data) : Builder
    __builder.where **match_data
  end
end
