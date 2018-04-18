- if monitor.up?
  - background = ""
- else
  - background = "background-red"
tr class=background
  - if type == "ping"
    td
      a href="#{monitor_path monitor}" ICMP Ping

  - if type == "http"
    td
      a href="#{monitor_path monitor}"
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
    a href="#{delete_monitor_path monitor}" Stop
