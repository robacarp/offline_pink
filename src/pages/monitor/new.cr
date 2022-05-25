class Monitor::NewPage < AuthLayout
  needs domain : Domain
  needs icmp_op : SaveIcmpMonitor
  needs http_op : SaveHttpMonitor

  needs selected_monitor : Symbol?

  def content
    fixed_width do
      h1 do
        text "New monitor for "
        text @domain.name
      end

      div class: "flex", style: "height: 25rem" do

        div class: "w-1/2 flex flex-col h-full tabs bg-gray-800", data_behavior: "tabs" do
          para class: "p-4" do
            text <<-TEXT
              When checking to see the status of a domain, Offline.pink first checks DNS for a list of hosts. For each resolved host, additional monitoring can be performed."
            TEXT
          end

          a class: class_list("p-4 block tab", active_if(:http == selected_monitor)), href: "#http" do
            text <<-TEXT
              HTTP is a high level application monitor which checks to the correctness and responsiveness
              of a web application. It is equivalent to the `curl` utility.
            TEXT
          end

          a class: class_list("p-4 block tab", active_if(:icmp == selected_monitor)), href: "#icmp" do
            text <<-TEXT
              ICMP Echo is a low level network monitor which checks to see a host is responsive
              and measures the time of that response. It is equivalent to the `ping` utility.
            TEXT
          end
        end

        div class: "w-1/2 h-full tab_panes" do
          pane_classes = %|pane p-4 bg-gray-500 h-full|

          div class: class_list(pane_classes, active_if(:http == selected_monitor)), id: "http" do
            h1 "HTTP"

            html_form
          end

          div class: class_list(pane_classes, active_if(:icmp == selected_monitor)), id: "icmp" do
            h1 "PING"

            icmp_form
          end

        end

      end

    end
  end

  def active_if(statement : Bool) : String
    return "active" if statement
    return ""
  end

  def meta_error(operation)
    unless operation.meta_error.blank?
      div class: "error" do
        text operation.meta_error
      end
    end
  end

  def icmp_form
    form_for MonitorIcmp::Create.with(id: @domain) do
      meta_error icmp_op
      submit "Add ICMP Ping Monitoring"
    end
  end

  def html_form
    form_for MonitorHttp::Create.with(id: @domain) do
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
