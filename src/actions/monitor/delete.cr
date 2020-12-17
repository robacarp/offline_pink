class Monitor::Delete < BrowserAction
  authorized_lookup Monitor

  delete "/monitor/:id" do
    monitor.delete
    redirect Domains::Show.with(monitor.domain_id)
  end
end
