require "../../test_helper"

describe "Domain#name" do
  let(:dns_error_message) {
    "Name should be the DNS name to be checked. For example: google.com instead of http://google.com/gmail"
  }

  it "cannot be blank" do
    domain = Generate.domain name: ""
    refute domain.valid?
    assert domain.errors.map(&.to_s).includes? "Name cannot be blank"
  end

  it "cant start with http" do
    domain = Generate.domain name: "http://yolo"
    refute domain.valid?
    assert domain.errors.map(&.to_s).includes? dns_error_message
  end

  it "cant contain slashes" do
    domain = Generate.domain name: "yolo/"
    refute domain.valid?
    assert domain.errors.map(&.to_s).includes? dns_error_message
  end

  it "cant be duplicated for the same user" do
    u = Generate.user!
    name = "example.com"
    domain1 = Generate.domain! name: name, user_id: u.id
    assert domain1.valid?
    domain2 = Generate.domain name: name, user_id: u.id
    refute domain2.valid?
    assert domain2.errors.map(&.to_s).includes? "Name is already being checked"
  end
end
