class Domains::New < BrowserAction
  include Sift::DontEnforceAuthorization

  get "/my/domains/new" do
    html NewPage, save: SaveDomain.new
  end
end
