require "../../test_helper"

describe "User#password" do
  it "cannot be blank" do
    u = Generate.user
    u.crypted_password = nil
    refute u.valid?
    u.errors.map(&.to_s).includes? "Password cannot be blank"
  end

  it "can be compared" do
    u = Generate.user! password: "12345"
    refute u.check_password("2468")
    assert u.check_password("12345")
  end
end
