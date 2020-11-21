abstract class BaseModel < Avram::Model
  def self.database : Avram::Database.class
    AppDatabase
  end

  def global_id : String
    "gid://#{self.class.name}/#{id}"
  end

  macro policy!
    class BasePolicy < ::ApplicationPolicy
      def initialize(@user : User, @object : {{ @type }})
      end
    end
  end
end
