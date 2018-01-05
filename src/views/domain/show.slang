h3 == domain.name

| Checking #{domain.routes.size} routes:

- if domain.routes.any?
  ul
    - domain.routes.each do |route|
      li
        a href="/route/#{route.id}" == route.path

h4 Most recent pings:

- if domain.ip_addresses.any?
  table.table.table-dark
    tr
      th scope="col" Address
      th scope="col"
      th scope="col" Last Ping
      th scope="col" Latency
    - domain.ip_addresses.each do |address|
      tr
        th scope="row" == address.address
        td
          - if address.last_result.is_up?
            .green [UP]
          - else
            - if address.last_result.checked?
              .red [DOWN]
            - else
              .pink [UNCHECKED]
        td == address.last_result.relative_time_since
        td == address.last_result.response_time

a href="/domain/#{domain.id}/routes/new" Create a route
