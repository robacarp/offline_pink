require "../../test_helper"

describe "Domain#monitor_results" do
  it "returns all the monitor_results connected to this domain" do
    domain = Generate.domain!
    monitor_results = Array(MonitorResult).new(3) do |_|
      Generate.http_monitor_result! domain_id: domain.id
    end.map(&.id!).sort

    assert_equal(
      monitor_results,
      domain.monitor_results.select.map(&.id!).sort
    )
  end
end
