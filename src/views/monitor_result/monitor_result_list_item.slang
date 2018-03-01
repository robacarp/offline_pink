- if type == "ping"
  .row.result-header title="Result##{result.id}"
    .col-md-6.text-right Response Time
    .col-md-3 -
    .col-md-3 #{result.ping_response_time}ms

- if type == "http"
  .row.result-header title="Result##{result.id}"
    .col-md-6.text-left
      | GET
      strong
        = monitor.http_full_url
  .row
    .col-md-6.text-right Response Time
    .col-md-3 -
    .col-md-3 #{result.http_response_time}ms
  .row
    .col-md-6.text-right Status Code
    - if monitor.http_expected_status_code == result.http_response_code
      - color = "background-green"
    - else
      - color = "background-red"
    .col-md-3 class=color
      = monitor.http_expected_status_code
    .col-md-3 class=color
      = result.http_response_code
  - if monitor.search_content?
    tr
      th.text-right scope="row" Text Search
      td = monitor.http_expected_content
      td = result.http_content_found
