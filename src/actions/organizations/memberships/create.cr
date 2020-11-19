class Organizations::Memberships::Create < BrowserAction
  post "/organization/:id/invite" do
    organization = OrganizationQuery.new
      .where_memberships(MembershipQuery.new.user_id(current_user.id))
      .find(id)

    SaveInvite.create(params, organization) do |operation, invite|
      if invite
        flash.success = "Invitation sent"
        redirect Organizations::Show.route(organization)
      else
        flash.failure = "Cannot create invitation"
        html Organizations::Memberships::NewPage, organization: organization, save: operation
      end
    end
  end
end
