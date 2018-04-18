.row
  .col-md-6.offset-md-3
    h3
      = domain.name
      | ::
      = monitor.type
  .col-md-6.text-right
    a href="#{delete_monitor_path monitor}" stop this monitor

.row
  .col-md-6.offset-md-3
    - if monitor.type == :ping
      == render partial: "ping.slang"
    - else
      == render partial: "get.slang"
