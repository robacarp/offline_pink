class Domains::ShowPage < AuthLayout
  needs domain : Domain

  def content
    small_frame do
      header_and_links do
        h1 do
          text domain.name
          middot_sep
          text domain.status_code.to_s.downcase
        end

        div do
          link "Stop Monitoring", to: Domains::Delete.with(domain), data_confirm: "Are you sure?"
          middot_sep
          link "Add Another Monitor", to: Monitor::Create.with(domain)
        end
      end

      verification_messaging

      centered do
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

  def verification_messaging
    return if domain.verification_status == Domain::Verification::Verified

    if domain.verification_status == Domain::Verification::UnChecked
      mount Shared::AlertBox do
        para "This domain has not been verified yet so monitoring is limited."
        para do
          link "Verify domain ownership", to: Domains::Verification::Show.with(domain)
          text " to begin periodic monitoring."
        end
      end
    end

    if domain.verification_status == Domain::Verification::Failed
      mount Shared::AlertBox, severity: "failure", title: "Warning", classes: "mb-4" do
        div do
          para "This domain has failed ownership verification and monitoring is disabled."
          para do
            link "Verify domain ownership", to: Domains::Verification::Show.with(domain)
            text " to resume monitoring."
          end
        end
      end
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
        link log_line.text, to: MonitorEvent::Show.with(
          monitor_id,
          log_line.monitor_event.to_unix
        )
      else
        text log_line.text
      end
    end
  end
end
