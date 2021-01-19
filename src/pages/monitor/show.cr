abstract class Monitor::ShowPage < AuthLayout
  needs monitor : Monitor
  needs domain : Domain

  abstract def graphs

  def content
    small_frame do
      header_and_links do
        h1 do
          link domain.name, to: Domains::Show.with(domain)
          middot_sep
          text monitor.summary
        end

        div do
          link "stop monitoring", to: Monitor::Delete.with(monitor), data_confirm: "Are you sure?"
        end
      end

      if monitor.last_succeeded_at < 3.days.ago
        para do
          text "This monitor hasn't succeded in over 3 days and will be disabled soon"
        end
      end

      last_monitor_output
      graphs
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

  def chart_for(endpoint, *, name : String = "chart", type : String = "chart" )
    div("", {
        data_chart_url: endpoint.path,
        data_chart_name: name,
        data_chart_type: type,
        data_refresh_progress: 0
      }, [:data_chart]
    )
  end
end
