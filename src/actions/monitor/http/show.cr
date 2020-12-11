class Monitor::Http::Show < BrowserAction
  include Sift::DontEnforceAuthorization

  get "/monitor/http/:id" do
    monitor = Monitor::HttpQuery.new.find id
    html ShowPage, monitor: monitor
  end
end
