module Featurette
  class Database < Avram::Database
  end

  abstract class BaseModel < Avram::Model
    def to_param
      id.to_s
    end

    def self.database : Avram::Database.class
      Database
    end
  end
end
