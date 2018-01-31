class Granite::ORM::Base
  include Pink::Validator

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
