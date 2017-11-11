div.row
  div.col-sm-11
    h2 Checks
  div.col-sm-1
    a.btn.btn-success.btn-xs href="/checks/new" New
div.table-responsive
  table.table.table-striped
    tbody
    - checks.each do |check|
      tr
        td
          == link_to check.host.to_s, "checks/#{check.id}"
