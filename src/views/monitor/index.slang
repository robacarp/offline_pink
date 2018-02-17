.row
  .col-md-6
    h3
      a href="/domain/#{domain.id}" = domain.name
      | has #{domain.monitors.count} monitors:
  .col-md-6.text-right
    a href="/domain/#{domain.id}/monitors/new" Create a new monitor

.row
  .col-md-8.offset-md-2
    - if domain.monitors.any?
      - domain.grouped_monitors.each do |type, monitors|
        h4= type
        .row
          .col-md-11.offset-md-1
            table.table.table-dark
              - monitors.each do |monitor|
                == render partial: "monitor/monitor_list_item.slang"

    - else # no monitors exist
      .alert.alert-info
        h4 This domain isn't currently being monitored!
        p
          | Would you like to
          a href="/domain/#{domain.id}/monitors/new" create a monitor?
