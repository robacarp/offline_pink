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
    refute monitor.valid?
    assert monitor.errors.map(&.to_s).includes? "Monitor must be one of http, icmp"
  end

  it "can find the last associated result" do
    skip
  end

  it "is #up? when the last result is #ok?" do
    skip
  end

  it "is #down? when it is not #up?" do
    skip
  end
end

