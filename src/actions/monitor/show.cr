class Monitor::Show < BrowserAction
  get "/monitor/:id" do
    monitor = MonitorQuery.new.preload_domain.find(id)

    case monitor.monitor_type
    when Monitor::Type::Http
      html Monitor::Http::ShowPage, monitor: monitor, domain: monitor.domain
    when Monitor::Type::Icmp
      html Monitor::Icmp::ShowPage, monitor: monitor, domain: monitor.domain
    else
      flash.keep
      flash.failure = "cannot show that monitor: #{monitor.monitor_type}"
      redirect Home::Index
    end
  end
end
