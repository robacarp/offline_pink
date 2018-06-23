require "../../test_helper"

describe "Domain associations" do
  it "are cascade destroyed" do
    domain = Generate.domain!
    monitor = Generate.http_monitor! domain_id: domain.id
    monitor_result = Generate.http_monitor_result! domain_id: domain.id

    refute domain.new_record?
    refute monitor.new_record?
    refute monitor_result.new_record?

    assert domain.destroy
    refute Monitor.find(monitor.id)
    refute MonitorResult.find(monitor_result.id)
  end
end
