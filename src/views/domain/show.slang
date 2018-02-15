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
    h4= type
    .row
      .col-md-11.offset-md-1
        table.table.table-dark
          - monitors.each do |monitor|
            == render partial: "monitor/monitor_list_item.slang"


br
a href="/domain/#{domain.id}/monitors/new" Create a new monitor

/
