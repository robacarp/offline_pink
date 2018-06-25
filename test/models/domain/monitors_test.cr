require "../../test_helper"

describe "Domain#monitors" do
  it "returns all the monitors for this domain" do
    domain = Generate.domain!
    monitors = Array(Monitor).new(3) do
      Generate.http_monitor! domain_id: domain.id
    end.map(&.id!).sort

    assert_equal(
      monitors,
      domain.monitors.select.map(&.id!).sort
    )
  end

  it "grouped monitors groups by type" do
    domain = Generate.domain!

    icmp_monitors = [
      Generate.icmp_monitor! domain_id: domain.id
    ].map(&.id!).sort

    http_monitors = Array(Monitor).new(3) do
      Generate.http_monitor! domain_id: domain.id
    end.map(&.id!).sort

    assert_equal(
      icmp_monitors,
      domain.grouped_monitors["ping"].map(&.id!).sort
    )

    assert_equal(
      http_monitors,
      domain.grouped_monitors["http"].map(&.id!).sort
    )
  end
end
