require "../../test_helper"

describe "Domain#user_id" do
  it "must exist" do
    domain = Generate.domain user_id: nil
    refute domain.valid?
    assert domain.errors.map(&.to_s).includes? "User must be assigned"
  end

  it "is a user" do
    assert_instance_of User, Generate.domain.user
  end
end
