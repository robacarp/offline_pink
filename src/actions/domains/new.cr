class Domains::New < BrowserAction
  get "/my/domains/new" do
    html NewPage, save: SaveDomain.new(user: current_user)
  end
end
