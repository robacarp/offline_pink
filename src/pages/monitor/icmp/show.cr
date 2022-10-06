class Monitor::Icmp::ShowPage < Monitor::ShowPage
  def graphs
    hr
    chart_for monitor, metric: "icmp_response_time", name: "Ping Response Time"
  end
end
