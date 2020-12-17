class Monitor::Create < BrowserAction
  authorized_lookup Domain, :update

  get "/domain/:id/monitors/create" do
    html NewPage,
      domain: domain,
      icmp_op: SaveIcmpMonitor.new(domain: domain),
      http_op: SaveHttpMonitor.new(domain: domain)
  end
end
