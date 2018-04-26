.row
  .col-md-6.offset-md-2
    h4
      | Host detail for
      = host.address
      - if host.up?
        span.green.text-right [OK]
      - elsif host.down?
        span.pink.text-right [Offline]
      - else
        - success, _, total = host.last_result_summary
        span.yellow.text-right
          br
          | [Not Ok]
          | (#{success}/#{total} monitors passing)
  .col-md-2.text-right
    a href="#{domain_path host.domain}" Back to domain

.row
  .col-md-8.offset-md-2
    .row
      .col-md-3.offset-md-6 Expected
      .col-md-3 Actual

    .result-table
      - host.last_results_grouped_by_type.each do |type, results|
        .row.result-type
          .col-md-8.offset-md-2
            h5= type
        - results.each do |result|
          - monitor = result.monitor
          == render partial: "monitor_result/monitor_result_list_item.slang"
