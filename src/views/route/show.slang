.row
  .col-md-6
    h3 = route.full_path
  .col-md-6.text-right
    a href="/route/#{route.id}/delete" stop checking this route

.row
  .col-md-8.offset-md-2
    table.table.table-dark
      - if result.checked?
        tr
          th scope="row" Status
          td
            - if result.is_up?
              .green [up]
            - else
              .red [down]
      tr
        th scope="row" Last Checked
        td = result.relative_time_since
      - if result.checked?
        tr
          th scope="row" Response time
          td
            = result.response_time
            | ms
        - if route.search_for_content?
          tr
            th scope="row" Search Text
            td
              = route.expected_content
              - if result.found_expected_content?
                .green [found]
              - else
                .red [missing]
