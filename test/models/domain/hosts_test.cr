require "../../test_helper"

describe "Domain#hosts" do
  it "returns all the hosts connected to this domain" do
    domain = Generate.domain!
    hosts = Array(Host).new(3).map do
      Generate.host! domain_id: domain.id
    end.sort {|a,b| a.id! <=> b.id! }

    assert_equal(
      hosts,
      domain.hosts.select.sort {|a,b| a.id! <=> b.id! }
    )
  end
end
