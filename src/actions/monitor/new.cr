class Monitor::Create < BrowserAction
  get "/domain/:id/monitors/create" do
    domain = DomainQuery.new.find(id)
    authorize domain, DomainPolicy, :update?

    html NewPage,
      domain: domain,
      icmp_op: SaveIcmpMonitor.new(domain: domain),
      http_op: SaveHttpMonitor.new(domain: domain)
  end
end
