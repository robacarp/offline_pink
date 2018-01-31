class Granite::ORM::Base
  include Pink::Validator

  # Hack to get crystal compiler to recognize that these methods will
  # be here eventually, and will always return a string.
  #
  # These methods must be defined in finished, because they must be
  # undefined when macros run. The eventual existence of the method
  # is overshadowed by the macro definition of the same name so they
  # cannot be defined before the end of the macro run.
  #
  # Additionally, it doesn't seem like crystal supports abstract class
  # methods.
  macro finished
    def self.table_name
      ""
    end

    def self.primary_name
      ""
    end

    def self.adapter : Nil | Granite::Adapter::Base
    end

    def self.fields : Array(String)
      [] of String
    end

    def self.from_sql(result)
    end
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
