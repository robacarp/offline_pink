require "../../test_helper"

describe "Host fields" do
  it "ip version is automatically guessed" do
    host = Generate.host address: "1.2.3.4"
    host.guess_version
    assert host.ip_version == "ipv4"

    host = Generate.host address: "1:2:3:4"
    host.guess_version
    assert host.ip_version == "ipv6"
  end

  it "status sets status_code" do
    host = Generate.host
    host.status = Host::Status::Up
    assert host.status_code == Host::Status::Up.to_i
  end

  it "status defaults to UnChecked" do
    host = Generate.host
    assert host.status == Host::Status::UnChecked
  end

  it "status populates from the status_code" do
    host = Generate.host status_code: Host::Status::Down.to_i
    assert host.status == Host::Status::Down
  end
end
