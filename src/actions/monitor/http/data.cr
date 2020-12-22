class Monitor::Http::Data < BrowserAction
  authorized_lookup Monitor, :read

  get "/monitor/:id/data.json" do
    metric_name = params.get?("metric") || "none"

    metrics = MetricQuery.new
      .monitor_id(monitor.id)
      .name(metric_name)
      .created_at.gt(1.hour.ago)
      .created_at.desc_order

    json MetricSerializer.for_collection metrics
  end
end
