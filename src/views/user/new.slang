.row
  .col-md-6.offset-md-3
    h1 Register

    - if user.errors
      ul.errors
      - user.errors.each do |error|
        li = error.to_s

    - unless invite
      .alert.alert-info
        | Use of Offline.Pink is currently by invite only. You can register for an account but will not be able to use Offline.pink for monitoring until your account is activated.
    == form action: new_user_path, method: :post do
      == csrf_tag
      div.form-group
        == text_field name: "email", value: user.email, placeholder: "Email", class: "form-control"
      div.form-group
        == text_field type: :password, name: "password", value: user.password, placeholder: "Password", class: "form-control"
      div.form-group
        == submit "Submit", class: "btn btn-primary btn-xs"
