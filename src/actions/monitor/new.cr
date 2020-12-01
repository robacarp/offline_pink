class Monitor::Create < BrowserAction
  authorized_lookup Domain, :update

  get "/domain/:id/monitors/create" do
    html NewPage,
      domain: domain,
      icmp_op: Monitor::Icmp::Save.new(domain: domain),
      http_op: Monitor::Http::Save.new(domain: domain)
  end
end
