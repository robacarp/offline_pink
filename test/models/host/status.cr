require "../../test_helper"

describe "Host status" do
  let(:run_time) { Time.now }

  it "up? is true when no results are failing" do
    host = Generate.host!
    successful_results = Array(MonitorResult).new(3) do |_|
      Generate.http_monitor_result! host_id: host.id, domain_id: host.domain_id, run_start_time: run_time, ok: true
    end

    assert host.up?
    refute host.down?
    refute host.partial_up?
  end

  it "partial_up? is true when some results are passing and some are failing" do
    host = Generate.host!

    successful_results = Array(MonitorResult).new(3) do |_|
      Generate.http_monitor_result! host_id: host.id, domain_id: host.domain_id, run_start_time: run_time, ok: true
    end

    failing_results = Array(MonitorResult).new(3) do |_|
      Generate.http_monitor_result! host_id: host.id, domain_id: host.domain_id, run_start_time: run_time, ok: false
    end

    assert host.partial_up?
    refute host.up?
    refute host.down?
  end

  it "down? is true when none of the results are passing" do
    host = Generate.host!

    failing_results = Array(MonitorResult).new(3) do |_|
      Generate.http_monitor_result! host_id: host.id, domain_id: host.domain_id, run_start_time: run_time, ok: false
    end

    assert host.down?
    refute host.partial_up?
    refute host.up?
  end
end
