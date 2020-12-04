class Organizations::New < BrowserAction
  get "/my/organizations/new" do
    authorize_operation(->{ SaveOrganization.new(user: current_user) }) do |authorized_operation|
      html NewPage, save: authorized_operation
    end
  end
end
