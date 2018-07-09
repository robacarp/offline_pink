require "../test_helper"

describe "SentNotification" do
  let(:sent_notification) { Generate.sent_notification }
  let(:downtime) { SentNotification::Reason::Downtime }
  let(:slack) { SentNotification::Vendor::Slack }

  it "has the correct default reason" do
    assert_equal SentNotification::Reason::Undefined, sent_notification.reason
  end

  it "updates the reason code when setting reason" do
    sent_notification.reason = downtime
    assert_equal downtime.to_i, sent_notification.reason_code
  end


  it "updates the vendor code when setting vendor" do
    sent_notification.vendor = slack
    assert_equal slack.to_i, sent_notification.vendor_code
  end

  it "has the correct default vendor" do
    assert_equal SentNotification::Vendor::Undefined, sent_notification.vendor
  end
end
