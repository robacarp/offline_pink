require "granite_orm/adapter/pg"

class Check < Granite::ORM::Base
  adapter pg

  field get_request : Bool
  field ping_check : Bool
  field host : String
  field url : String

  timestamps

  belongs_to :user
  has_many :ping_results
  has_many :get_results

  VALID_TYPES = {1 => :ping, 2 => :get}

  def ping_check?
    ping_check
  end

  def get_request?
    get_request
  end

  def last_ping : PingResult | Nil
    result = PingResult.all("WHERE check_id = ? ORDER BY id DESC LIMIT 1", [id])
    if result.any?
      result.first
    end
  end

  def last_get : GetResult | Nil
    result = GetResult.all("WHERE check_id = ? ORDER BY id DESC LIMIT 1", [id])
    if result.any?
      result.first
    end
  end
end
