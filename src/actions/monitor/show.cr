class Monitor::Show < BrowserAction
  authorized_lookup Monitor do |query|
    query.preload_domain
  end

  get "/monitor/:id" do
    case monitor.monitor_type
    when Monitor.http.to_i
      html Monitor::Http::ShowPage, monitor: monitor, domain: monitor.domain
    when Monitor.icmp.to_i
      html Monitor::Icmp::ShowPage, monitor: monitor, domain: monitor.domain
    else
      flash.keep
      flash.failure = "cannot show that monitor: #{monitor.monitor_type}"
      redirect Home::Index
    end
  end
end
