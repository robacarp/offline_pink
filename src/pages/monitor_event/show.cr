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
        log_entries.each do |entry|
          div do
            text entry.text
          end
        end
      end
    end
  end
end
