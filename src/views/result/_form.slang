- if result.errors
  ul.errors
  - result.errors.each do |error|
    li = error.to_s

== form(action: "/results/#{result.id.to_s}", method: result.id ? :patch : :post) do
  == csrf_tag
  div.form-group
  div.checkbox
    == label(:is_up)
    == check_box(:is_up, checked: result.is_up.to_s == "1")
  div.form-group
    == label(:check)
    == select_field(name: "check_id", collection: Check.all.map{|check| [check.id, check.id]}, selected: result.check_id, class: "form-control")
  == submit("Submit", class: "btn btn-primary btn-xs")
  == link_to("back", "/results", class: "btn btn-default btn-xs")
