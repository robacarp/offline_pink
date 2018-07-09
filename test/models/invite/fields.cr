require "../../test_helper"

describe "Invite fields" do
  let(:invite) { Generate.invite }

  it "generates a code on save" do
    invite.save
    refute invite.code!.blank?
  end

  it "counts invited users" do
    assert_equal 0, invite.invited_user_count
  end

  it "can be used" do
    assert invite.use!
  end
end
