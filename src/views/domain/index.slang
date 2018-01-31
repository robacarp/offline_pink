h3 Monitored Domains
- if domains.any?
  table.table.table-dark
    - domains.each do |domain|
      tr
        td
          a href="/domain/#{domain.id}"
            = domain.name
        td
          - if domain.is_invalid?
            .red [invalid]
          - elsif domain.checked?
            - if domain.up?
              .green [up]
            - else
              .red [down]
          - else
            .pink [unchecked]
  br
a href="/my/domains/new" Monitor a new domain
