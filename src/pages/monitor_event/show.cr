class MonitorEvent::ShowPage < AuthLayout
  needs metric_data : Array(Metric)
  needs log_entries : Array(LogEntry)
  needs monitor : Monitor
  needs monitor_event : Time

  def content
    small_frame do
      header_and_links do
        h1 do
          text monitor.domain.name
          text " - "
          text monitor.summary
        end

        div do
          text monitor_event
        end
      end

      centered do
        h2 "Per Host Metrics"

        div class: "mb-8" do
          metric_data.group_by(&.host).each do |host, metrics|
            h3(host || "0")

            div class: "mb-8" do
              metrics.each do |metric|
                text metric_name_humanizer metric.name
                text ": "
                text metric.string_value
                text metric_unit_humanizer metric.units
                br
              end
            end
          end
        end

        h2 "Log Entries"

        log_entries.each do |entry|
          div do
            text entry.text
          end
        end
      end
    end
  end
end
