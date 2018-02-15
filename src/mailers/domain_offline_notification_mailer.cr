class DomainOfflineNotificationMailer < ApplicationMailer
  @host : Host

  def initialize(
    @user : User,
    @domain : Domain,
    @result : PingResult
  )
    @host = @result.ip_address.not_nil!

    to @user.email.not_nil!
    subject "Domain Offline : Offline.pink"
    body render("mailers/notification_email.ecr")
  end
end
