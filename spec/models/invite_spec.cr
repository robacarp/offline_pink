require "../spec_helper"
require "../../src/models/invite.cr"

describe Invite do
  context "code" do
    it "is generated" do
      invite = Generate.invite!
      invite.code.not_nil!.size.should eq 20
    end

    it "isn't consistent" do
      invite = Generate.invite
      invite.generate_code.should_not eq invite.generate_code
    end
  end
end
