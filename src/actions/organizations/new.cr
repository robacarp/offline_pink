class Organizations::New < BrowserAction
  get "/my/organizations/new" do
    html NewPage, save: SaveOrganization.new(user: current_user)
  end
end
