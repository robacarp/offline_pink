class Domains::Show < BrowserAction
  authorized_lookup Domain do |query|
    query.preload_monitors
  end

  get "/domains/:id" do
    html ShowPage, domain: domain
  end
end
