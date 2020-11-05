class Monitors::NewPage < AuthLayout
  needs domain : Domain
  needs icmp_form : Monitors::ICMP::Form
  needs http_form : Monitors::HTTP::Form

  def content
    div class: "row" do
      div class: "col-md-8 offset-md-2" do
        h1 do
          text "New monitor for "
          text @domain.name
        end

        para "When checking to see the status of a domain, Offline.pink first checks DNS for a list of hosts. For all resolved hosts, additional monitoring can be performed."

        ul class: "nav nav-pills" do
          li class: "h5 nav-item my-auto mr-1" do
            text "Monitor type"
          end

          li class: "nav-item" do
            a "HTTP", class: "nav-link", data_toggle: "tab", href: "#http"
          end

          li class: "nav-item" do
            a "ICMP", class: "nav-link", data_toggle: "tab", href: "#icmp"
          end
        end

        div class: "tab-content" do
          div id: "icmp", class: "tab-pane" do
            h1 class: "PING"
            para do
              text <<-TEXT
                ICMP Echo is a low level network monitor which checks to see a host is responsive
                and measures the time of that response. It is equivalent to the 
              TEXT
              a "ping", href: "https://en.wikipedia.org/wiki/Ping_%28networking_utility%29"
              text " utility."
            end

            icmp_form
          end

          div id: "http", class: "tab-pane" do
            h1 "HTTP"
            para do
              text <<-TEXT
                HTTP is a high level application monitor which checks to the correctness and responsiveness
                of a web application. It is equivalent to the 
              TEXT
              a "curl", href: "https://en.wikipedia.org/wiki/CURL"
              text " utility."
            end

            html_form
          end
        end

      end
    end
  end


  def icmp_form
    form_for Monitors::ICMP::Create.route(domain_id: @domain) do
      submit "Add ICMP Ping Monitor", class: "btn"
    end
  end

  def html_form
    form_for Monitors::HTTP::Create.route(domain_id: @domain) do
      field(@http_form.path) { |i| text_input i, class: "form-control" }
      field(@http_form.ssl) { |i| check_box i, class: "form-control" }
    end
  end
end
