require "granite_orm/adapter/pg"

class PingResult < Granite::ORM::Base
  extend Query::BuilderMethods

  adapter pg

  belongs_to :ip_address

  field is_up : Bool
  field response_time : Float32
  field ip_address_id : Int64

  timestamps

  table_name "ping_results"

  include RelativeTime

  def is_up?
    is_up
  end

  def checked?
    ! created_at.nil?
  end
end
