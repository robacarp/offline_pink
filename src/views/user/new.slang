h1 Register

.row
  .col-md-6.offset-md-3
    - if user.errors
      ul.errors
      - user.errors.each do |error|
        li = error.to_s

    == form action: new_user_path, method: :post do
      == csrf_tag
      div.form-group
        == text_field name: "email", value: user.email, placeholder: "Email", class: "form-control"
      div.form-group
        == text_field type: :password, name: "password", value: user.password, placeholder: "Password", class: "form-control"
      div.form-group
        == submit "Submit", class: "btn btn-primary btn-xs"
