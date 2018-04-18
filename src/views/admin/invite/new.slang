.row
  .col-md-6.offset-md-3
    h1 Create Invitation

    - if invite.errors
      ul.errors
        - invite.errors.each do |error|
          li = error.to_s

    == form action: admin_invites_path, method: :post do
      == csrf_tag
      div.form-group
        == label :uses_remaining, "Uses remaining:"
        == text_field type: :number, name: "uses_remaining", value: 1, class: "form-control"
      == submit "Submit", class: "btn btn-primary btn-xs"
