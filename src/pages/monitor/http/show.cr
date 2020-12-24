class Monitor::Http::ShowPage < Monitor::ShowPage
  def graphs
    hr
    chart_for Monitor::Data.with(monitor, metric: "http_response_time"), name: "HTTP Response Time", type: "http_response_time"
    chart_for Monitor::Data.with(monitor, metric: "http_status_code"), name: "HTTP Status Code", type: "http_status_code"
  end
end
