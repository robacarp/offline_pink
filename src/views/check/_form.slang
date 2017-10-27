- if check.errors
  ul.errors
  - check.errors.each do |error|
    li = error.to_s

== form(action: "/checks/#{check.id.to_s}", method: check.id ? :patch : :post) do
  == csrf_tag
  div.form-group
  == text_field(name: "type", value: check.type, placeholder: "Type", class: "form-control")
  div.form-group
  == text_field(name: "reference", value: check.reference, placeholder: "Reference", class: "form-control")
  == submit("Submit", class: "btn btn-primary btn-xs")
  == link_to("back", "/checks", class: "btn btn-default btn-xs")
