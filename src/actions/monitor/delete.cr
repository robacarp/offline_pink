class Monitor::Delete < BrowserAction
  delete "/monitor/:id" do
    monitor = MonitorQuery.new.find(id)
    authorize monitor

    monitor.delete
    redirect Domains::Show.with(monitor.domain_id)
  end
end
