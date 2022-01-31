class Domains::ShowPage < AuthLayout
  needs domain : Domain

  def content
    small_frame do
      header_and_links do
        h1 do
          text domain.name
          middot_sep
          text formatted_status for: domain
        end

        div do
          link "Stop Monitoring", to: Domains::Delete.with(domain), data_confirm: "Are you sure?"
          middot_sep
          link "Add Another Monitor", to: Monitor::Create.with(domain)
        end
      end

      shrink_to_fit do
        ul do
          domain.monitors.each do |monitor|
            li do
              link_to_monitor monitor
            end
          end
        end
      end

      last_monitor_output
    end
  end

  def link_to_monitor(monitor : Monitor)
    action = Monitor::Show.with monitor

    if action
      link monitor.summary, to: action
    else
      text monitor.summary
    end
  end

  def last_monitor_output
    output = domain.last_monitor_output

    if output.select_count <= 0
      para "No monitor logs"
      return
    end

    header_and_links do
      h1 "Last Montor Run"
    end

    div class: "log-output" do
      output.each do |log_line|
        clickable_log_line log_line
        br
      end
    end
  end

  def clickable_log_line(log_line : LogEntry)
    classes = ["entry"]
    classes << log_line.severity.to_s.downcase

    if log_line.attached_monitor?
      classes << "monitor"
    end

    span class: classes.join(' ') do
      if monitor_id = log_line.monitor_id
        # todo fix link color, add icon for click-ability
        link log_line.text, to: MonitorEvent::Show.with(monitor_id, log_line.monitor_event.to_unix)
      else
        text log_line.text
      end
    end
  end
end
