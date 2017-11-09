require "granite_orm/adapter/pg"

class Check < Granite::ORM::Base
  adapter pg

  field get_request : Bool
  field ping_check : Bool
  field host : String
  field url : String

  timestamps

  belongs_to :user

  VALID_TYPES = {1 => :ping, 2 => :get}

  def ping_check?
    ping_check
  end

  def get_request?
    get_request
  end
end
