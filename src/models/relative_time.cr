module RelativeTime
  def relative_time_since : String
    unless timestamp = created_at
      return "never"
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

  def relative_created_at : String
    unless timestamp = created_at
      return "never"
    end

    now = Time.now.to_utc
    delta = now - timestamp

    case
    when delta < 10.seconds
      "just now"
    when delta < 59.seconds
      "< 1m ago"
    when delta < 59.minutes
      "#{delta.minutes}m ago"
    when delta < 24.hours
      "#{delta.hours}h ago"
    when delta < 1.week
      "#{delta.days}d ago"
    else
      "#{delta.total_weeks.round 1} weeks ago"
    end
  end
end
