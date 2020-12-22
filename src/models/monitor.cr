class Monitor < BaseModel
  avram_enum Type do
    Http = 1
    Icmp = 2
  end

  table do
    column monitor_type : Int32
    column config : JSON::Any
    belongs_to domain : Domain
    belongs_to region : Region
    has_many metrics : Metric
  end

  policy!

  def summary
    monitor_config.summary
  end

  {% begin %}
  {% types = [:icmp, :http] %}
  {% for type, index in types %}
      def self.{{ type.id }}
        Monitor::Type.new( {{ type }} )
      end
  {% end %}
  {% end %}

  alias Any = Icmp | Http

  def monitor_config : Any
    case monitor_type
    when self.class.icmp.to_i
      Monitor::Icmp.from_json(config.to_json)
    when self.class.http.to_i
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
