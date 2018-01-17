.row
  .col-md-6.offset-md-3
    h3 Monitor New Domain
    - if domain.errors
      ul.errors
        - domain.errors.each do |error|
          li = error.to_s

    == form action: "/my/domains/new", method: :post do
      == csrf_tag
      .form_group
        == text_field name: "name", value: domain.name, placeholder: "offline.pink", class: "form-control"
      .form-group
        == submit "Submit", class: "btn"
