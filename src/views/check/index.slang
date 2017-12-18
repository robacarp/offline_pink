.row
  .col-md-6
.row
  .col-md-6.offset-md-3
    .container
      .row
        .col-md-6
          h2 Checks
        .col-md-6.text-right
          a.btn.btn-success.btn-xs href="/checks/new" New
    .table-responsive
      table.table.table-striped
        tbody
        - checks.each do |check|
          tr
            td
              == link_to check.uri.to_s, "checks/#{check.id}"
            - if check.ping_check?
              td [PING]
              td
                - if ping = check.last_ping
                  - if ping.is_up
                    | Alive #{ping.relative_time_since}, #{ping.response_time}ms
                  - else
                    .pink
                      | Dead
                - else
                  | Not Pinged yet
            - else
              td
              td
            - if check.get_request?
              td [GET]
              td
                - if get = check.last_get
                  - if get.is_up
                    | Alive #{get.relative_time_since}, #{get.response_time}ms
                  - else
                    .pink
                      | Dead
                - else
                  | Not requested yet
            - else
              td
              td
