class Monitor::Create < BrowserAction
  get "/domain/:domain_id/monitors/create" do
    domain = DomainQuery.new.user_id(current_user.id).find domain_id

    html NewPage,
      domain: domain,
      icmp_op: Monitor::Icmp::Save.new(domain: domain),
      http_op: Monitor::Http::Save.new(domain: domain)
  end
end
