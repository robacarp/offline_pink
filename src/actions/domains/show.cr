class Domains::Show < BrowserAction
  authorized_lookup Domain do |query|
    query.preload_icmp_monitors
         .preload_http_monitors
  end

  get "/domains/:id" do
    html ShowPage, domain: domain
  end
end
