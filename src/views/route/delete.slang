.row
  .col-md-6.offset-md-3
    h3
      | Stop watching path
      = route.full_path

    == form action: "/route/#{route.id}", method: :delete do
      == csrf_tag
      .form_group
        == check_box name: "confirm", checked: false
        == label :confirm, "Stop checking #{route.full_path}"
      .form_group
        == submit "Disable monitoring", class: "btn"

