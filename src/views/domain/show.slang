.row
  .col-md-6
    h3 = domain.name
  .col-md-6.text-right
    a href="/domain/#{domain.id}/delete" stop monitoring this domain

- if domain.is_invalid?
  .alert.alert-danger
    | This domain has been marked as invalid and monitoring has stopped.
    br
    | Options:
    ul
      li
        a href="/domain/#{domain.id}/revalidate" Try again
        | if you think the error was temporary or
      li
        a href="/domain/#{domain.id}/delete" Stop monitoring
        | if the domain is incorrect.

- if domain.monitors.any?
  | #{domain.monitors.count} monitors:

  - domain.grouped_monitors.each do |type, monitors|
    h4 type
    ul
      - monitors.each do |monitor|
        li
          a href="/monitor/#{monitor.id}"
            = monitor.id
            = monitor.type

br
a href="/domain/#{domain.id}/monitors/new" Create a new monitor

hr

h4 Most recent results:

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
        td title="Result##{address.last_result.id}"
          - if address.last_result.is_up?
            .green [up]
          - else
            - if address.last_result.checked?
              .red [down]
            - else
              .pink [unchecked]
        td = address.last_result.relative_time_since
        td
          = "#{address.last_result.response_time}ms"
        td
          a href="/ip_address/#{address.id}/delete" forget
