require "granite_orm/adapter/pg"

class Result < Granite::ORM::Base
  adapter pg

  belongs_to :check

  field is_up : Bool
  field response_time : Float32
  timestamps
end
