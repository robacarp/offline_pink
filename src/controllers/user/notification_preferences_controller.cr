class User::NotificationPreferencesController < ApplicationController
  authorize_with User::NotificationPreferencesPolicy, User

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

  end
end
