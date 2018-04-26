.row
  .col-md-6.offset-md-2
    h3 Monitored Domains
  .col-md-2
    a href="#{new_domain_path}" Monitor a new domain
- if domains.any?
  .row
    .col-md-8.offset-md-2
      table.table.table-dark
        - domains.each do |domain|
          tr
            td
              a href="#{domain_path domain}"
                = domain.name
