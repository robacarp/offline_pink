class Organizations::Create < BrowserAction
  post "/my/organizations/new" do
    SaveOrganization.create(params, user: current_user) do |operation, organization|
      if organization
        flash.success = "You've created a new organization"
        redirect Organizations::Show.route(organization.id)
      else
        flash.failure = "Could not create an organization"
        html NewPage, save: operation
      end
    end
  end
end
