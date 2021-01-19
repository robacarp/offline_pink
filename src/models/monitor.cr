class Monitor < BaseModel
  avram_enum Type do
    Http = 1
    Icmp = 2
  end

  table do
    column monitor_type : Int32
    column config : JSON::Any
    column last_succeeded_at : Time
    belongs_to domain : Domain
    belongs_to region : Region
    has_many metrics : Metric
  end

  policy!

  def summary
    monitor_config.summary
  end

  alias Any = Icmp | Http

  def monitor_config : Any
    case monitor_type
    when Monitor::Type::Icmp
      Monitor::Icmp.from_json(config.to_json)
    when Monitor::Type::Http
      Monitor::Http.from_json(config.to_json)
    else
      raise "cannot produce a monitor config for #{monitor_type}"
    end
  end

  def last_monitor_output
    last_run = LogEntryQuery.new
      .monitor_id(id)
      .monitor_event
      .select_max

    if last_run
      LogEntryQuery.new
        .monitor_id(id)
        .monitor_event(last_run)
    else
      LogEntryQuery.new.none
    end
  end
end
