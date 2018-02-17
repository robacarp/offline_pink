.row
  .col-md-6.offset-md-2
    h4
      | Host detail for
      = host.address
      - success, failure, total = host.last_result_summary
      - if success == total
        span.green.text-right [OK]
      - elsif failure == total
        span.pink.text-right [Offline]
      - else# failure != total && success != total
        span.yellow.text-right
          br
          | [Not Ok]
          | (#{success}/#{total} monitors passing)
  .col-md-2.text-right
    a href="/domain/#{host.domain_id}" Back to domain

.row
  .col-md-8.offset-md-2
    - host.last_results_grouped_by_type.each do |type, results|
      h5= type
      table.table.table-dark
        - results.each do |result|
          - monitor = result.monitor
          == render partial: "monitor_result/monitor_result_list_item.slang"
