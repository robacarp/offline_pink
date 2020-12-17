class Monitor::Show < BrowserAction
  authorized_lookup Monitor do |query|
    query.preload_domain
  end

  get "/monitor/:id" do
    html Monitor::ShowPage, monitor: monitor, domain: monitor.domain
  end
end
