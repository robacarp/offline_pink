require "../../test_helper"

describe "User&guest" do
  it "is not a registered user" do
    assert User.guest_user.guest?
  end

  it "a registered user is not a guest" do
    refute Generate.user!.guest?
  end
end
