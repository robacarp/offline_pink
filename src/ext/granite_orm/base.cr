class Granite::ORM::Base
  def validate : Nil
  end

  def valid? : Bool
    clean_errors
    validate
    errors.none?
  end

  def clean_errors
    errors = [] of Error
  end

  def add_error(field : Symbol, message : String)
    errors << Error.new(field, message)
  end

  def new_record?
    @id.nil?
  end

  macro __field_bang
    {% for name, type in FIELDS %}
      property! {{name.id}} : Union({{type.id}} | Nil)
    {% end %}
  end

  macro inherited
    macro finished
      __field_bang
    end
  end
end
