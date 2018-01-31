class Query::Builder(T)
  alias FieldName = String
  alias FieldData = DB::Any

  def initialize(@boolean_operator = :and)
    @fields = {} of FieldName => FieldData
  end

  def compile
    Compiled(T).new self
  end

  def runner
    Runner(T).new compile
  end

  def where(**matches)
    matches.each do |field, data|
      @fields[field.to_s] = data
    end

    self
  end

  def build_where(parameter_count = 1) : { String, Array(FieldName), Array(FieldData) }
    data = [] of FieldData
    parameter_count += 1
    clause = @fields.map do |field, value|
      data << value
      "#{field} = $#{parameter_count}"
    end.join " AND "

    { clause, T.fields, data }
  end

  def count : Int64
    runner.count
  end

  def first : T?
    first(1).first?
  end

  def first(n : Int32) : Array(T)
    runner.first(n)
  end
end
