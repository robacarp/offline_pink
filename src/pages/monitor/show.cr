class Monitor::ShowPage < AuthLayout
  needs monitor : Monitor
  needs domain : Domain

  def content
    small_frame do
      header_and_links do
        h1 do
          text domain.name
          middot_sep
          text monitor.summary
        end

        div do
          link "stop monitoring", to: Monitor::Delete.with(monitor), data_confirm: "Are you sure?"
        end
      end

      last_monitor_output
    end
  end

  def last_monitor_output
    output = monitor.last_monitor_output

    if output.select_count <= 0
      para "No monitor logs"
      return
    end

    div class: "log-output" do
      output.each do |log_line|
        classes = ["entry"]
        classes << log_line.severity.to_s.downcase
        classes << "monitor" if log_line.attached_monitor?

        span class: classes.join(' ') do
          text log_line.text
        end

        br
      end
    end
  end
end
