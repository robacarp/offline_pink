class Monitor::Data < BrowserAction
  authorized_lookup Monitor, :read
  param metric : String = "none"

  get "/monitor/:id/data.json" do
    metrics = MetricQuery.new
      .monitor_id(monitor.id)
      .name(metric)
      .created_at.gt(1.hour.ago)
      .created_at.desc_order

    json MetricSerializer.for_collection metrics
  end
end
