abstract class BaseModel < Avram::Model
  include Sift::Model

  def self.database : Avram::Database.class
    AppDatabase
  end

  def global_id : String
    "gid://#{self.class.name}/#{id}"
  end
end
