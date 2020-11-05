class Domains::Show < BrowserAction
  get "/domains/:id" do
    html ShowPage, domain: DomainQuery.new.preload_icmp_monitors.find(id)
  end
end
