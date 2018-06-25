require "../../test_helper"

describe "IcmpMonitor" do
  it "doesnt allow duplicate monitors" do
    duplicate_error_message = "Monitor is already being checked"

    domain = Generate.domain!
    monitor1 = Generate.icmp_monitor! domain_id: domain.id
    refute monitor1.new_record?

    monitor2 = Generate.icmp_monitor domain_id: domain.id
    assert monitor2.save
    refute monitor2.errors.any?
  end
end
