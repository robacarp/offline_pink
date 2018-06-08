class User::NotificationPreferencesController < ApplicationController
  authorize_with User::NotificationPreferencesPolicy, User
  require_activated_user

  def edit
    user = current_user
    authorize user

    unless user
      redirect_to domains_path
      return
    end

    render "edit.slang"
  end

  def update
    user = current_user
    authorize user

    unless user
      redirect_to domains_path
      return
    end

    if (pushover_key = params["pushover_key"]?) && ! pushover_key.includes?('*')
      user.pushover_key = pushover_key
    else
      redirect_to notification_preferences_path
    end

    if user.save
      flash["success"] = "Preferences updated."
      redirect_to notification_preferences_path
    else
      flash["danger"] = "Could not save preferences!"
      render "edit.slang"
    end
  end
end
