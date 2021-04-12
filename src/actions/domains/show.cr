class Domains::Show < BrowserAction
  get "/domains/:id" do
    domain = DomainQuery.new.preload_monitors.find(id)
    authorize domain
    html ShowPage, domain: domain
  end
end
