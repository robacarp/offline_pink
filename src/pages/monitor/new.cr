class Monitor::NewPage < AuthLayout
  needs domain : Domain
  needs icmp_op : Monitor::Icmp::Save
  needs http_op : Monitor::Http::Save

  def content
    h1 do
      text "New monitor for "
      text @domain.name
    end

    para "When checking to see the status of a domain, Offline.pink first checks DNS for a list of hosts. For all resolved hosts, additional monitoring can be performed."

    text "Monitor type"
    a "HTTP", class: "nav-link", data_toggle: "tab", href: "#http"
    a "ICMP", class: "nav-link", data_toggle: "tab", href: "#icmp"

    h1 class: "PING"
    para do
      text <<-TEXT
        ICMP Echo is a low level network monitor which checks to see a host is responsive
        and measures the time of that response. It is equivalent to the 
      TEXT
      a "ping", href: "https://en.wikipedia.org/wiki/Ping_%28networking_utility%29"
      text " utility."
    end

    # icmp_form

    h1 "HTTP"
    para do
      text <<-TEXT
        HTTP is a high level application monitor which checks to the correctness and responsiveness
        of a web application. It is equivalent to the 
      TEXT
      a "curl", href: "https://en.wikipedia.org/wiki/CURL"
      text " utility."
    end

    # html_form
  end

  def icmp_form
    form_for Monitor::Icmp::Create.route(domain_id: @domain) do
      submit "Add ICMP Ping Monitor", class: "btn"
    end
  end

  def html_form
    form_for Monitor::Http::Create.route(domain_id: @domain) do
      field(@http_form.path) { |i| text_input i, class: "form-control" }
      field(@http_form.ssl) { |i| check_box i, class: "form-control" }
    end
  end
end
