tr
  - if type == "ping"
    td
      a href="/monitor/#{monitor.id}" ICMP Ping

  - if type == "http"
    td
      a href="/monitor/#{monitor.id}"
        | GET
        = monitor.http_path
    td
      - if monitor.http_use_ssl
        span.pink SSL
      - else
        strike SSL
    td
      | HTTP Status ==
      = monitor.http_expected_status_code
    td
      | Content == "
      = monitor.http_expected_content
      | "

  td.text-right
    a href="/monitor/#{monitor.id}/delete" Stop
