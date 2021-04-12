class Domains::New < BrowserAction
  get "/my/domains/new" do
    html NewPage, save: SaveDomain.new
  end
end
