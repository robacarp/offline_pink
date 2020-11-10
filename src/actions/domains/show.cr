class Domains::Show < BrowserAction
  get "/domains/:id" do
    d = DomainQuery.new
      .user_id(current_user.id)
      .preload_icmp_monitors
      .preload_http_monitors
      .find(id)

    html ShowPage, domain: d
  end
end
