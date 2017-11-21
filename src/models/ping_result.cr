require "granite_orm/adapter/pg"

class PingResult < Granite::ORM::Base
  adapter pg

  belongs_to :check

  field is_up : Bool
  field response_time : Float32

  timestamps

  table_name "ping_results"

  def relative_time_since : String
    unless timestamp = created_at
      raise "Cannot compute timestamp for unsaved results"
    end

    now = Time.now.to_utc
    delta = now - timestamp

    case
    when delta < 10.seconds
      "just now"
    when delta < 59.seconds
      "< 1m"
    when delta < 59.minutes
      "#{delta.minutes}m"
    when delta < 24.hours
      "#{delta.hours}h"
    else
      "too long ago"
    end
  end

  def is_up?
    is_up
  end
end
