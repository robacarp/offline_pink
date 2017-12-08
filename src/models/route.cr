require "granite_orm/adapter/pg"

class Route < Granite::ORM::Base
  adapter pg

  field path : String
  field expected_content : String
  field expected_code : Int64
  field use_ssl : Bool
  timestamps

  belongs_to :domain
end
