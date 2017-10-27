require "granite_orm/adapter/pg"

class Check < Granite::ORM::Base
  adapter pg

  field type : String
  field reference : String
  timestamps

  belongs_to :user
end
