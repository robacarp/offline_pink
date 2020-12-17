class Monitor::Show < BrowserAction
  include Sift::DontEnforceAuthorization

  get "/monitor/:id" do
    monitor = MonitorQuery.new.find id

    case Monitor::Type.new monitor.monitor_type
    when Monitor.http
      html Monitor::Http::ShowPage, monitor: monitor
    when Monitor.icmp
      html Monitor::Icmp::ShowPage, monitor: monitor
    else
      flash.keep
      flash.failure = "cannot show that monitor: #{monitor.monitor_type}"
      redirect Home::Index
    end
  end
end
