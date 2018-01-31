.row
  .col-md-6.offset-md-3
    h3
      | Forget about #{ip_address.address}
    p #{ip_address.address} has been associated with #{domain.name} by DNS.
    p If DNS for #{domain.name} still points to #{ip_address.address} it will be automatically re-added the next time a Ping check is performed.

    == form action: "/ip_address/#{ip_address.id}", method: :delete do
      == csrf_tag
      .form_group
        == check_box name: "confirm", checked: false
        == label :confirm, "Disable monitoring of #{ip_address.address}"
      .form_group
        == submit "Disable monitoring", class: "btn"
