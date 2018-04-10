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
end
