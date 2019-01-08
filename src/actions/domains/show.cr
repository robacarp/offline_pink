class Domains::Show < BrowserAction
  get "/domains/:id" do
    render ShowPage, domain: DomainQuery.new.preload_icmp_monitors.find(id)
  end
end
