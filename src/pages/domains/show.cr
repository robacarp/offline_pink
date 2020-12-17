class Domains::ShowPage < AuthLayout
  needs domain : Domain

  def content
    div class: "w-1/2 mx-auto" do
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
