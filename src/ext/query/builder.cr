class Query::Builder
  alias FieldName = String
  alias FieldData = DB::Any

  getter model

  def initialize(@model : Granite::ORM::Base.class, @boolean_operator = :and)
    @fields = {} of FieldName => FieldData
  end

  def compile
    Compiled.new self
  end

  def runner
    Runner.new compile, @model, @model.adapter.as(Granite::Adapter::Base)
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

    { clause, @model.fields, data }
  end

  def count : Int64
    runner.count
  end

  def first
    runner.first
  end
end
