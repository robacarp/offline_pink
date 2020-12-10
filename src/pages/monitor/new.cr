class Monitor::NewPage < AuthLayout
  needs domain : Domain
  needs icmp_op : Monitor::Icmp::Save
  needs http_op : Monitor::Http::Save

  needs selected_monitor : Symbol?

  def content
    fixed_width do
      h1 do
        text "New monitor for "
        text @domain.name
      end

      div class: "left-right-chooser" do

        div class: "left tabs", data_behavior: "tabs" do
          para "When checking to see the status of a domain, Offline.pink first checks DNS for a list of hosts. For each resolved host, additional monitoring can be performed."

          a class: active_if(:http == selected_monitor, "tab"), data_toggle: "tab", href: "#http" do
            text <<-TEXT
              HTTP is a high level application monitor which checks to the correctness and responsiveness
              of a web application. It is equivalent to the `curl` utility.
            TEXT
          end

          a class: active_if(:icmp == selected_monitor, "tab"), data_toggle: "tab", href: "#icmp" do
            text <<-TEXT
              ICMP Echo is a low level network monitor which checks to see a host is responsive
              and measures the time of that response. It is equivalent to the `ping` utility.
            TEXT
          end
        end

        div class: "right tab_panes" do

          div class: active_if(:http == selected_monitor, "pane"), id: "http" do
            h1 "HTTP"

            html_form
          end

          div class: active_if(:icmp == selected_monitor, "pane"), id: "icmp" do
            h1 "PING"

            icmp_form
          end

        end

      end

    end
  end

  def active_if(statement : Bool, always base_classes : String) : String
    base_classes += " active" if statement
    base_classes
  end

  def meta_error(operation)
    unless operation.meta_error.blank?
      div class: "error" do
        text operation.meta_error
      end
    end
  end

  def icmp_form
    form_for Monitor::Icmp::Create.with(id: @domain) do
      meta_error icmp_op
      submit "Add ICMP Ping Monitoring"
    end
  end

  def html_form
    form_for Monitor::Http::Create.with(id: @domain) do
      meta_error http_op

      div class: "flex justify-between items-start" do
        div do
          mount Shared::Field, attribute: http_op.path, &.text_input
          mount Shared::Checkbox, attribute: http_op.ssl, label_text: "SSL", &.checkbox
          mount Shared::Field, attribute: http_op.expected_status_code, &.number_input(min: 100, max: 599)
        end

        mount Shared::Field, attribute: http_op.expected_content, &.textarea
      end

      submit "Add new HTTP Monitor"
    end
  end
end
