class Domains::Verification::Show < BrowserAction
  ensure_feature_permitted :domain_monitoring

  get "/domains/:id/verification" do
    domain = DomainQuery.new.find(id)
    authorize domain, DomainPolicy, :edit?
    html ShowPage, domain: domain
  end
end
