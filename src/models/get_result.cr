require "granite_orm/adapter/pg"
require "./relative_time"

class GetResult < Granite::ORM::Base
  adapter pg

  belongs_to :check

  field is_up : Bool
  field response_time : Float32
  field response_code : Int32

  belongs_to :route
  timestamps

  table_name "get_results"

  include RelativeTime

  def is_up?
    is_up
  end

  def checked?
    ! created_at.nil?
  end
end
