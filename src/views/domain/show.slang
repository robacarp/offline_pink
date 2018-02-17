.row
  .col-md-6
    h3 = domain.name
  .col-md-6.text-right
    a href="/domain/#{domain.id}/delete" stop monitoring this domain
    br
    a href="/domain/#{domain.id}/monitors" manage this domains monitors

- if domain.is_invalid?
  .alert.alert-danger
    | This domain has been marked as invalid and monitoring has stopped.
    br
    | Options:
    ul
      li
        a href="/domain/#{domain.id}/revalidate" Try again
        | if you think the error was temporary or
      li
        a href="/domain/#{domain.id}/delete" Stop monitoring
        | if the domain is incorrect.

- if domain.hosts.any?
  h3 Host Status

  table.table.table-dark
    - domain.hosts.each do |host|
      tr
        td = host.address
        - success, failure, total = host.last_result_summary
        - if success == total
          td.green.text-right [OK]
        - elsif failure == total
          td.pink.text-right [Offline]
        - else# failure != total && success != total
          td.yellow.text-right
            | [Not Ok] (#{success}/#{total} monitors passing)
        td
          a href="/host/#{host.id}/last_results" Details
