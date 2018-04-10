h1 Show Invite
p = invite.code
p = invite.uses_remaining
p
  == link_to("back", "/invites", class: "btn btn-default btn-xs")
  == link_to("edit", "/invites/#{invite.id}/edit", class: "btn btn-success btn-xs")
  == link_to("delete", "/invites/#{invite.id}?_csrf=#{csrf_token}", "data-method": "delete", "data-confirm": "Are you sure?", class: "btn btn-danger btn-xs")
