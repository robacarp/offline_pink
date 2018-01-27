require "quartz_mailer"

class ApplicationMailer < Quartz::Composer
  def sender
    address "Offline.pink", "notification-monkey@offline.pink"
  end
end
