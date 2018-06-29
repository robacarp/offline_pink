require "../../test_helper"

describe "PushoverKey verification" do
  let(:code) { "12345" }
  let(:pushover_key) { Generate.pushover_key }

  it "knows when it can send a verification" do
    pushover_key.verification_sent_at = nil
    assert pushover_key.can_send_verification?

    pushover_key.verification_sent_at = 61.minutes.ago
    assert pushover_key.can_send_verification?

    pushover_key.verification_sent_at = 59.minutes.ago
    refute pushover_key.can_send_verification?
  end

  it "knows when a verification code is valid" do
    pushover_key.verification_sent_at = nil
    refute pushover_key.can_verify?

    pushover_key.verification_sent_at = 61.minutes.ago
    refute pushover_key.can_verify?

    pushover_key.verification_sent_at = 59.minutes.ago
    assert pushover_key.can_verify?
  end

  it "sets verified = false when generating a new code" do
    pushover_key.verified = true
    pushover_key.generate_verification_code
    refute pushover_key.verified
  end

  it "will not verify unless #can_verify?" do
    pushover_key.verification_code = code
    pushover_key.verification_sent_at = nil
    refute pushover_key.verify! code

    pushover_key.verification_sent_at = 1.minute.ago
    assert pushover_key.verify! code
  end

  it "marks it as verified when the correct code is given" do
    pushover_key.verification_code = code
    assert pushover_key.verify! code
    assert pushover_key.verified

    pushover_key.verified = false
    refute pushover_key.verify! "#{code}1"
    refute pushover_key.verified
  end

  it "makes note of the verification sent time" do
    pushover_key.verification_code = code
    assert pushover_key.verify!(code)
    assert pushover_key.verified?, "pushover key is not verified"
  end
end
