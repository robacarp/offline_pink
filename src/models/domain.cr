require "granite_orm/adapter/pg"

class Domain < Granite::ORM::Base
  adapter pg

  field name : String
  timestamps

  belongs_to :user
  has_many :routes
end
