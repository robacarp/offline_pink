.row
  .col-md-6.offset-md-3
    h3
      | Disable monitoring of
      = domain.name

    == form action: "/domain/#{domain.id}", method: :delete do
      == csrf_tag
      .form_group
        == check_box name: "confirm", checked: false
        == label :confirm, "Disable monitoring of #{domain.name}"
      .form_group
        == submit "Disable monitoring", class: "btn"
