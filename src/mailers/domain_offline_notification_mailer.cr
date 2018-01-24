class DomainOfflineNotificationMailer < ApplicationMailer
  def initialize(@user : User, @domain : Domain)
    to @user.email.not_nil!
    subject "Domain Offline : Offline.pink"
    body render("mailers/notification_email.slang")
  end
end
