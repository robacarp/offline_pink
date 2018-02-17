- if type == "ping"
  tr title="Result##{result.id}"
    th scope="row" Response Time
    td #{result.ping_response_time}ms

- if type == "http"
  tr title="Result##{result.id}"
    th.text-center
      | GET
      strong
        = monitor.http_full_url
    th scope="col" Expected
    th scope="col" Actual
  tr
    th.text-right scope="row" Response Time
    td #{result.http_response_time}ms
    td
      | -
  tr
    th.text-right scope="row" Status Code
    td = monitor.http_expected_status_code
    td = result.http_response_code
  - if monitor.search_content?
    tr
      th.text-right scope="row" Text Search
      td = monitor.http_expected_content
      td = result.http_content_found
