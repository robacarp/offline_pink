.row
  .col-md-6.offset-md-3
    h3
      | Disable monitoring

    == form action: monitor_path(monitor), method: :delete do
      == csrf_tag
      .form_group
        == check_box name: "confirm", checked: false
        == label :confirm, "Disable monitoring of #{domain.name}::#{monitor.type}"
      .form_group
        == submit "Disable monitoring", class: "btn"
