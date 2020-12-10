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

      table class: "mx-auto w-64 table-zebra table-borders" do
        domain.monitors.each do |monitor|
          tr do
            td monitor.type
            td monitor.string_config
          end
        end
      end

      last_monitor_output
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
        span class: log_line.severity.to_s.downcase do
          text log_line.text
        end

        br
      end
    end
  end
end
