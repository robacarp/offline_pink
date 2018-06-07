.row
  .col-md-6.offset-md-3
    h3 Account

    - if user.errors
      ul.errors
      - user.errors.each do |error|
        li = error.to_s

    == form action: edit_account_path, method: :post do
      == csrf_tag
      h4 Credentials
      p To update email or password, provide your current password.
      div.form-group
        == text_field type: :password, name: "current_password", placeholder: "Current Password", class: "form-control"
        br
        == text_field name: "email", value: user.email, placeholder: "Email", class: "form-control"
        br
        == text_field type: :password, name: "password", value: new_password, placeholder: "New Password", class: "form-control"
      div.form-group
        == submit "Submit", class: "btn btn-primary btn-xs"
