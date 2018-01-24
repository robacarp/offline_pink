require "email"

class ApplicationMailer < Amber::Mailer
  def sender
    address "Offline.pink", "notification-monkey@offline.pink"
  end
end
