div.row
  div.col-md-10
    h2 Invites
  div.col-md-2
    a href="#{new_admin_invite_path}" Create invite
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
            == link_to admin_invite_path(invite) do
              = invite.code
          td
            = invite.invited_user_count
            == "/"
            = invite.uses_remaining
          td
            a href="#{invited_user_registration_path(invite)}" invite url
          td
            span
              == link_to "delete", admin_invite_path(invite, _csrf: csrf_token), "data-method": "delete", "data-confirm": "Are you sure?"
