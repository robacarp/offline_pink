- if check.errors
  ul.errors
  - check.errors.each do |error|
    li = error.to_s

== form action: "/checks/#{check.id.to_s}", method: check.id ? :patch : :post do
  == csrf_tag
  div.form-group
    == text_field name: "uri", value: check.uri, placeholder: "http://offline.pink/", class: "form-control"
  div.form-group
    == check_box name: "get_request", checked: check.get_request
    == label :get_request, "Send GET request"
  div.form-group
    == check_box name: "ping_check", checked: check.ping_check
    == label :ping_check, "Ping host?"
  div.form-group
    == submit "Submit", class: "btn btn-primary btn-xs"
  == link_to "back", "/checks", class: "btn btn-default btn-xs"
