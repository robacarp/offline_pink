require "../../test_helper"

describe "User#email" do
  it "cannot be blank" do
    user = User.new email: ""
    refute user.valid?
    assert user.errors.map(&.to_s).includes? "Email cannot be blank"
  end

  it "cannot be duplicated" do
    email = "user@example.com"
    existing_user = Generate.user! email: email
    refute existing_user.new_record?

    user = Generate.user email: email
    refute user.valid?
    assert user.errors.map(&.to_s).includes? "Email is already registered"
  end
end
