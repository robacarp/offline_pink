module Featurette
  abstract class BaseModel < Avram::Model
    def to_param
      id.to_s
    end

    def self.database : Avram::Database.class
      ::AppDatabase
    end
  end
end
