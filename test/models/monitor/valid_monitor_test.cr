require "../../test_helper"

describe "Monitor" do
  it "requires a domain to be assigned" do
    monitor = Generate.http_monitor domain_id: nil
    refute monitor.valid?
    assert monitor.errors.map(&.to_s).includes? "Domain must be assigned"
  end

  it "requires that monitor_type be http or icmp" do
    monitor = Generate.http_monitor
    monitor.monitor_type = "yolo"
    refute monitor.valid?, "Monitor should not be valid, but is"

    assert monitor.errors.map(&.to_s).includes? "Monitor type must be one of ping, http"
  end

  it "can find the last associated result" do
    monitor = Generate.http_monitor!
    old_result = Generate.http_monitor_result! monitor_id: monitor.id
    new_result = Generate.http_monitor_result! monitor_id: monitor.id
    refute new_result.new_record?
    assert_equal new_result.id, monitor.last_result.id
  end

  it "is #up? when the last result is #ok?" do
    monitor = Generate.http_monitor!
    result = Generate.http_monitor_result! ok: true, monitor_id: monitor.id
    assert monitor.up?
  end

  it "is #down? when the last result is not #ok?" do
    monitor = Generate.http_monitor!
    result = Generate.http_monitor_result! ok: false, monitor_id: monitor.id
    refute monitor.up?
  end
end

