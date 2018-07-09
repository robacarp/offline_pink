require "../../test_helper"

describe "MonitorResult set" do
  let(:time) { Time.now }

  it "finds a collection of matching results" do
    host = Generate.host!
    result = Generate.http_monitor_result! host_id: host.id, run_start_time: time

    unrelated_result = Generate.http_monitor_result!
    unrelated_result = Generate.http_monitor_result! host_id: host.id

    related_results = Array(MonitorResult).new(3) do |_|
      Generate.http_monitor_result! host_id: host.id, run_start_time: time
    end

    assert_equal(
      [result, related_results].flatten.map(&.id!).sort,
      result.matching_result_set.map(&.id!).sort
    )
  end
end
