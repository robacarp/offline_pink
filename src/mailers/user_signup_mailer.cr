class UserSignupMailer < ApplicationMailer
  def initialize(@user : User)
    to "admin@offline.pink"
    subject "New User : Offline.pink"
    body render("mailers/user_signup_email.ecr")
  end
end
