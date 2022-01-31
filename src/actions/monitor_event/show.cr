class MonitorEvent::Show < BrowserAction
  get "/monitor/:id/event/:timestamp" do
    monitor = MonitorQuery.new.preload_domain.find id
    monitor_event = Time.unix timestamp.to_i
    log_entries = LogEntryQuery.new.monitor_id(id).monitor_event(monitor_event)
    metric_data = MetricQuery.new.monitor_id(id).monitor_event(monitor_event)

    html MonitorEvent::ShowPage,
      log_entries: log_entries.to_a,
      metric_data: metric_data.to_a,
      monitor_event: monitor_event,
      monitor: monitor
  end
end
