require "../../test_helper"

describe "Host associations" do
  let(:run_time) { Time.now }

  it "destroys all associations on destroy" do
    host = Generate.host!
    monitor_result = Generate.http_monitor_result! host_id: host.id, run_start_time: run_time
    assert_equal 1, host.monitor_results.select.size
    assert host.destroy
    refute MonitorResult.find(monitor_result.id)
  end

  it "returns all monitor results" do
    host = Generate.host!
    expected_ids = Array(MonitorResult).new(3) do |_|
      Generate.http_monitor_result! host_id: host.id, run_start_time: run_time
    end.map(&.id!).sort

    assert_equal(
      expected_ids,
      host.monitor_results.map(&.id!).sort
    )
  end

  it "returns the most recent monitor result" do
    host = Generate.host!
    results = Array(MonitorResult).new(3) do |_|
      Generate.http_monitor_result! host_id: host.id, domain_id: host.domain_id, run_start_time: run_time
    end

    expected_result = Generate.http_monitor_result! host_id: host.id, domain_id: host.domain_id
    assert_equal expected_result.id!, host.last_result.id!
  end

  it "returns last results grouped by type" do
    host = Generate.host!

    http_results = Array(MonitorResult).new(3) do |_|
      Generate.http_monitor_result! host_id: host.id, domain_id: host.domain_id, run_start_time: run_time
    end

    icmp_results = Array(MonitorResult).new(3) do |_|
      Generate.ping_monitor_result! host_id: host.id, domain_id: host.domain_id, run_start_time: run_time
    end

    assert_equal(
      http_results.map(&.id!).sort,
      host.last_results_grouped_by_type["http"].map(&.id!).sort
    )

    assert_equal(
      icmp_results.map(&.id!).sort,
      host.last_results_grouped_by_type["ping"].map(&.id!).sort
    )
  end

  it "returns last results grouped by success" do
    host = Generate.host!
    successful_results = Array(MonitorResult).new(3) do |_|
      Generate.http_monitor_result! host_id: host.id, domain_id: host.domain_id, run_start_time: run_time, ok: true
    end
    failing_results = Array(MonitorResult).new(3) do |_|
      Generate.http_monitor_result! host_id: host.id, domain_id: host.domain_id, run_start_time: run_time, ok: false
    end

    assert_equal(
      successful_results.map(&.id!).sort,
      host.last_results_grouped_by_success[true].map(&.id!).sort
    )

    assert_equal(
      failing_results.map(&.id!).sort,
      host.last_results_grouped_by_success[false].map(&.id!).sort
    )
  end
end
