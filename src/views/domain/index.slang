.row
  .col-md-6.offset-md-2
    h3 Monitored Domains
  .col-md-2
    a href="/my/domains/new" Monitor a new domain
- if domains.any?
  .row
    .col-md-8.offset-md-2
      table.table.table-dark
        - domains.each do |domain|
          tr
            td
              a href="/domain/#{domain.id}"
                = domain.name
            td.text-center
              - if domain.is_invalid?
                .red [invalid]
              - else
                - if domain.up?
                  .green [up]
                - elsif domain.partial_up?
                  .yellow [unstable]
                - else
                  .pink [offline]
