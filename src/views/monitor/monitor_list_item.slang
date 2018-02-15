- if type == "ping"
  tr
    td
      a href="/monitor/#{monitor.id}" ICMP Ping
- if type == "http"
  tr
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

