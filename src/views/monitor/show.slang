.row
  .col-md-6
    h3
      = domain.name
      | ::
      = monitor.type

    - if monitor.type == :ping
      == render partial: "ping.slang"
    - else
      == render partial: "get.slang"
