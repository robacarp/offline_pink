require "../../test_helper"

describe "Host associations" do
  it "destroys all associations on destroy" do
    host = Generate.host!
    monitor_result = Generate.http_monitor_result! host_id: host.id
    assert_equal 1, host.monitor_results.select.size
    assert host.destroy
    refute MonitorResult.find(monitor_result.id)
  end

  it "returns all monitor results" do
    skip
  end

  it "returns the most recent monitor result" do
    skip
  end

  it "returns last results grouped by type" do
    skip
  end

  it "returns last results grouped by success" do
    skip
  end

  it "up? is true when no results are failing" do
    skip
  end

  it "partial_up? is true when some results are passing and some are failing" do
    skip
  end

  it "down? is true when none of the results are passing" do
    skip
  end
end
