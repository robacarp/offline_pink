.row
  .col-md-6
    h3 = domain.name
  .col-md-6.text-right
    a href="/domain/#{domain.id}/delete" stop monitoring this domain

| Checking #{domain.routes.size} routes:

- if domain.routes.any?
  table.table.table-dark
    tr
      th scope="col" Path
      th scope="col" Status
      th scope="col" Last Checked
      th scope="col" Response Time
    - domain.routes.each do |route|
      tr
        th scope="row"
          a href="/route/#{route.id}" = route.full_path
        td
          - if route.last_result.is_up?
            .green [up]
          - else
            - if route.last_result.checked?
              .red [down]
            - else
              .pink [unchecked]
        td = route.last_result.relative_time_since
        td
          = route.last_result.response_time
          | ms

a href="/domain/#{domain.id}/routes/new" Create a route

h4 Most recent pings:

- if domain.ip_addresses.any?
  table.table.table-dark
    tr
      th scope="col" Address
      th scope="col" Status
      th scope="col" Last Ping
      th scope="col" Latency
    - domain.ip_addresses.each do |address|
      tr
        th scope="row" == address.address
        td
          - if address.last_result.is_up?
            .green [up]
          - else
            - if address.last_result.checked?
              .red [down]
            - else
              .pink [unchecked]
        td == address.last_result.relative_time_since
        td
          == address.last_result.response_time
          | ms
