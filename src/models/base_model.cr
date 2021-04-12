abstract class BaseModel < Avram::Model
  def to_param
    id.to_s
  end

  def self.database : Avram::Database.class
    AppDatabase
  end

  def global_id : String
    "gid://#{self.class.name}/#{id}"
  end
end
