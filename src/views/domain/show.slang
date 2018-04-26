.row
  .col-md-6.offset-md-2
    h3 = domain.name
  .col-md-2.text-right
    a href="#{delete_domain_path domain}" stop monitoring
    br
    a href="#{domain_monitors_path domain}" manage monitors

.row
  .col-md-8.offset-md-2
    - if domain.is_invalid?
      .alert.alert-danger
        | This domain has been marked as invalid and monitoring has stopped.
        br
        | Options:
        ul
          li
            a href="#{revalidate_domain_path domain}" Try again
            | if you think the error was temporary or
          li
            a href="#{delete_domain_path domain}" Stop monitoring
            | if the domain is incorrect.

    - if domain.hosts.any?
      h3 Host Summary

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
              a href="/host/#{host.id}/last_results" details
