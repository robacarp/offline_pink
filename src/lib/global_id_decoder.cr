module GlobalID
  class DecodedOwner(Model)
    getter klass : Model.class
    getter id : Int64

    def initialize(@klass : Model, @id : Int64)
    end

    def initialize(klass, id : String)
      initialize klass, id.to_i64
    end

    # def find : Model
    #   query.find id
    # end

    def query
      {% begin %}
        case klass
          {% for type in @type.type_vars.first.union_types %}
            when {{ type }}
              {{ type }}Query.new
          {% end %}
        end
      {% debug() %}
      {% end %}
    end

    def model
      Model
    end

    def holds?(candidate : Model) : Bool
      true
    end

    def holds?(something_else) : Bool
      false
    end
  end

  class Decoder(PossibleTypes)
    def self.decode(global_id : String)
      unless global_id.starts_with? "gid://"
        raise "#{global_id} is not a global id"
      end

      klass, id = global_id[6..].split '/'

      {% begin %}
        case klass
          {% for type in @type.type_vars.first.union_types %}
            when "{{ type.id }}"
              DecodedOwner.new {{ type }}, id
          {% end %}
        else
          raise "Unknown class: #{klass}"
        end
        {% debug() %}
      {% end %}
    end
  end
end

class Base
  def find(int : Int64)
    true
  end
end

class User < Base
end
class UserQuery
end
class Organization < Base
end
class OtherThing < Base
end
class OrganizationQuery
end

decoder = GlobalID::Decoder(User|Organization)

["gid://User/1", "gid://Organization/1"].each do |gid|
  decoded = decoder.decode(gid)
  puts "\n#{gid}"
  puts "org #{decoded.holds?(Organization)}"
  puts "user #{decoded.holds?(User)}"
  puts decoded.model
end
