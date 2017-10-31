- if user.errors
  ul.errors
  - user.errors.each do |error|
    li = error.to_s

== form(action: "/users/#{user.id.to_s}", method: user.id ? :patch : :post) do
  == csrf_tag
  div.form-group
    == text_field(name: "email", value: user.email, placeholder: "Email", class: "form-control")
  div.form-group
    == text_field(name: "password", value: user.password, placeholder: "Password", class: "form-control")
  div.form-group
    == submit("Submit", class: "btn btn-primary btn-xs")
