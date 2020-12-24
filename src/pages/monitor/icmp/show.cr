class Monitor::Icmp::ShowPage < Monitor::ShowPage
  def graphs
    hr
    chart_for Monitor::Data.with(monitor, metric: "icmp_response_time"), name: "Ping Response Time", type: "icmp_response_time"
  end
end
