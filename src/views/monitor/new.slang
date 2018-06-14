.row
  .col-md-6.offset-md-3
    h3
      | New monitor for
      = domain.name

    - if monitor.errors
      ul.errors
        - monitor.errors.each do |error|
          li = error.to_s

    p
      | When checking to see the status of a domain, Offline.pink first checks DNS for a list
      | of hosts. For all resolved hosts, additional monitoring can be performed.
    p
      | To add an additional monitor select a monitor type:

    - ping_tab_active = monitor.monitor_type == "ping" ? "active" : ""
    - http_tab_active = monitor.monitor_type == "http" ? "active" : ""

    ul.nav.nav-pills
      li.nav-item.h5.my-auto.mr-1
        | Monitor Type:
      li.nav-item
        a.nav-link class=http_tab_active data-toggle="tab" href="#http" HTTP
      li.nav-item
        a.nav-link class=ping_tab_active data-toggle="tab" href="#ping" ICMP

    hr

    .tab-content
      .tab-pane#ping class=ping_tab_active
        p
          | ICMP Echo is a low level network monitor which checks to see a host is responsive
          | and measures the time of that response. It is equivalent to the
          a href="https://en.wikipedia.org/wiki/Ping_%28networking_utility%29" ping
          | utility.

        == form action: new_domain_monitor_path(domain), method: :post do
          == hidden_field name: :monitor_type, value: "ping"
          == submit "Add ICMP Ping monitor", class: "btn"

      .tab-pane#http class=http_tab_active
        p
          | HTTP is a high level application monitor which checks to the correctness and responsiveness
          | of a web application. It is equivalent to the
          a href="https://en.wikipedia.org/wiki/CURL" curl
          | utility.

        == form action: "#{new_domain_monitor_path domain}", method: :post do
          == csrf_tag
          == hidden_field name: :monitor_type, value: "http"
          .form_group
            == label :http_path, "Path to request:"
            == text_field name: :http_path, value: monitor.http_path, placeholder: "/", class: "form-control"
          .form_group
            == label :http_expected_content, "Expected raw html content to search for:"
            == text_field name: :http_expected_content, value: monitor.http_expected_content, placeholder: "<html>", class: "form-control"
          .form_group
            == label :http_expected_status_code, "Expected HTTP Status Code:"
            == text_field name: :http_expected_status_code, value: monitor.http_expected_status_code, placeholder: "200", class: "form-control"
          .form_group
            == check_box name: :http_use_ssl, checked: monitor.https?
            == label :http_use_ssl, "Use SSL?"
          .form_group
            == submit "Submit", class: "btn"
