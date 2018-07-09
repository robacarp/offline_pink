require "../../test_helper"

describe "PushoverKey fields" do
  let(:pushover_key) { Generate.pushover_key }

  it "can send when saved and verified" do
    assert pushover_key.new_record?
    assert pushover_key.save

    refute pushover_key.verified?
    refute pushover_key.can_send?

    pushover_key.verified = true
    assert pushover_key.can_send?
  end

  it "correctly masks the key" do
    pushover_key.key = "123456abcdefghijklmnopqrstuvwxyz"
    assert_equal  "************************stuvwxyz", pushover_key.masked
  end
end
