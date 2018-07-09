require "../../test_helper"

describe "User#pushover_key" do
  it "returns a key when it is available" do
    user = Generate.user!
    key = Generate.pushover_key! user_id: user.id
    refute User.find!(user.id).pushover_key.new_record?
  end

  it "creates a new key object when no key exists" do
    assert Generate.user!.pushover_key.new_record?
  end
end
