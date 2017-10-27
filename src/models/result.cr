require "granite_orm/adapter/pg"

class Result < Granite::ORM::Base
  adapter pg

  belongs_to :check

  # id : Int64 primary key is created for you
  field is_up : Bool
  timestamps
end
