abstract class BaseModel < Avram::Model
  def self.database : Avram::Database.class
    AppDatabase
  end

  def global_id : String
    "gid://#{self.class.name}/#{id}"
  end

  macro policy!
    abstract class BasePolicy < ::ApplicationPolicy
      def initialize(@user : User, @object : {{ @type }})
      end
    end

    abstract class BaseScope
      getter user : User
      getter query :  {{ @type }}Query

      def initialize(@user, @query)
      end

      abstract def scoped_query
    end
  end
end
