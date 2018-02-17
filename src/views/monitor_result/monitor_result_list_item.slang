- if type == "ping"
  tr title="Result##{result.id}"
    th.text-right scope="row" Response Time
    td #{result.ping_response_time}ms

- if type == "http"
  tr title="Result##{result.id}"
    th.text-left
      | GET
      strong
        = monitor.http_full_url
    th scope="col" Expected
    th scope="col" Actual
  tr
    th.text-right scope="row" Response Time
    td
      | -
    td #{result.http_response_time}ms
  tr
    th.text-right scope="row" Status Code
    - if monitor.http_expected_status_code == result.http_response_code
      - color = "bg-success"
    - else
      - color = "bg-danger"
    td class=color = monitor.http_expected_status_code
    td class=color = result.http_response_code
  - if monitor.search_content?
    tr
      th.text-right scope="row" Text Search
      td = monitor.http_expected_content
      td = result.http_content_found
