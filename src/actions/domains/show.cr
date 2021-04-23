class Domains::Show < BrowserAction
  ensure_feature_permitted :domain_monitoring

  get "/domains/:id" do
    domain = DomainQuery.new.preload_monitors.find(id)
    authorize domain
    html ShowPage, domain: domain
  end
end
