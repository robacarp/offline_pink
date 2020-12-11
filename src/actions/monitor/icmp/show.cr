class Monitor::Icmp::Show < BrowserAction
  include Sift::DontEnforceAuthorization

  get "/monitor/icmp/:id" do
    monitor = Monitor::IcmpQuery.new.find id
    html ShowPage, monitor: monitor
  end
end
