class Monitors::New < BrowserAction
  get "/domain/:domain_id/monitors/new" do
    domain = DomainQuery.new.find domain_id
    html HomePage
    # render(
    #   NewPage,
    #   icmp_form: Monitors::ICMP::Form.new(domain: domain),
    #   http_form: Monitors::HTTP::Form.new(domain: domain),
    #   domain: domain
    # )
  end
end
