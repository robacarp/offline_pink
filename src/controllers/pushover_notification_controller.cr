class PushoverNotificationController < ApplicationController
  authorize_with PushoverKeyPolicy, PushoverKey

  # require_activated_user
  before_action do
    all do
      # skip authenticating user for link verify
      next if action_name == :link_verify
      redirect_to "/" unless activated_user?
    end
  end

  def edit
    key = current_user.pushover_key
    authorize key
    render "edit.slang"
  end

  def update
    key = current_user.pushover_key
    authorize key

    if (new_key = params["pushover_key"]?) && ! new_key.includes?('*')
      key.key = new_key
      key.unverify!
    else
      redirect_to pushover_notification_settings_path
    end

    if key.save
      flash["success"] = "Pushover credentials updated. New keys must be verified before notifications will be sent."
      redirect_to pushover_notification_settings_path
    else
      flash["danger"] = "Could not save pushover key!"
      render "edit.slang"
    end
  end

  def verify
    key = current_user.pushover_key
    authorize key

    key.generate_verification_code

    unless key.can_send_verification?
      flash["warning"] = "Pushover credential verifications can only be attempted once per hour."
      return redirect_to pushover_notification_settings_path
    end

    unless key_string = key.key
      flash["warning"] = "Cannot send verification message to invalid pushover key"
      return redirect_to pushover_notification_settings_path
    end

    success = NotificationHandler
      .to(current_user)
      .reason(:verification)
      .title("Offline.pink Verification")
      .message("Your verification code is #{key.verification_code}.")
      .link(
        "Verify your pushover configuration now.",
        pushover_link_verification_url(current_user, key)
      )
      .send_pushover(validate_key: false)

    key.verification_sent!

    if success
      flash["success"] = "A message was sent."
    else
      flash["warning"] = "A message was attempted, but an error was received. Check your pushover key."
    end

    redirect_to pushover_notification_settings_path
  end

  def link_verify
    user = User.find params["user_id"]

    unless user
      flash["warning"] = "Cannot verify pushover credentials, no active user found."
      return redirect_to "/"
    end

    pushover_key = user.pushover_key
    authorize pushover_key, user: user

    if pushover_key.verify! params["code"]
      flash["success"] = "Your pushover key has been verified."
    else
      flash["danger"] = "Your pushover key verification could not be completed."
    end

    redirect_to "/"
  end
end
