.row
  .col-md-6
    h3 = "#{check.host}#{check.url}"
    - if check.ping_check?
      | [PING]
    - if check.get_request?
      | [GET]

    table.table.table-sm.table-hover
      - if check.ping_check?
        tr
          th scope="row" Last Ping
          td
            - if ping_result = check.last_ping
              | #{ping_result.relative_time_since}, #{ping_result.response_time}ms
            - else
              | No recent ping :<

      - if check.get_request?
        tr
          th scope="row" Last Get
          td
            - if get_result = check.last_get
              | #{get_result.relative_time_since}, #{get_result.response_time}ms
            - else
              | No recent GET :<

  .col-md-6.text-right
    a.btn.btn-xs href="/checks/#{ check.id }/edit" edit
    a.btn.btn-xs href="/checks/#{ check.id }?_method=delete" onclick="return confirm('Are you sure?');" delete
