class Domains::New < BrowserAction
  ensure_feature_permitted :domain_monitoring

  get "/my/domains/new" do
    html NewPage, save: SaveDomain.new
  end
end
