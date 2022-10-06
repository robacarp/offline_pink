class Monitor::Http::ShowPage < Monitor::ShowPage
  def graphs
    hr
    chart_for monitor, metric: "http_response_time", name: "HTTP Response Time"
    chart_for monitor, metric: "http_status_code", name: "HTTP Status Code"
  end
end
