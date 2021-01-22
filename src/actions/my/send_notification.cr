class My::SendTestNotification < BrowserAction
  include Sift::DontEnforceAuthorization

  post "/my/notification/test" do
    flash.keep

    if current_user.valid_pushover_settings?
      NotificationJob.new(
        user_id: current_user.id,
        title: "Offline.pink test",
        notification: "This is a test message from offline.pink"
      ).enqueue

      flash.success = "Test notification sent"
      redirect to: My::Account::Show
    else
      flash.failure = "No valid push notification token is available"
      redirect to: My::Account::Show
    end
  end
end
