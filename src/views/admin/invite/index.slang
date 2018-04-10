div.row
  div.col-md-10
    h2 Invites
  div.col-md-2
    a href="/admin/invites/new" Create invite
div.table-responsive
  table.table.table-striped
    thead
      tr
        th Code
        th Uses
        th
    tbody
      - invites.each do |invite|
        tr
          td
            == link_to "/admin/invites/#{invite.id}" do
              = invite.code
          td
            = invite.invited_user_count
            == "/"
            = invite.uses_remaining
          td
            span
              == link_to "delete", "/admin/invites/#{ invite.id }?_csrf=#{csrf_token}", "data-method": "delete", "data-confirm": "Are you sure?"
