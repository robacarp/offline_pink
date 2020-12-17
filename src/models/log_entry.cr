class LogEntry < BaseModel
  avram_enum Severity do
    Info = 2
    Notice = 3
    Warn = 4
    Error = 5
    Fatal = 6
  end

  table do
    column text : String
    column severity : LogEntry::Severity
    column monitor_event : Int64

    belongs_to domain : Domain?
    # belongs_to icmp_monitor : Monitor::Icmp?
    # belongs_to http_monitor : Monitor::Http?
    # polymorphic monitor, associations: [:icmp_monitor, :http_monitor], optional: true
  end

  {% begin %}
  {% levels = [:info, :notice, :warn, :error, :fatal] %}
  {% for level, index in levels %}
      def self.{{ level.id }}
        LogEntry::Severity.new( {{ level }} )
      end
  {% end %}
  {% end %}

  def attached_monitor?
    false #icmp_monitor_id || http_monitor_id
  end
end
