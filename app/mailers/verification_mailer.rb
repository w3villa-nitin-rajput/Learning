# app/mailers/verification_mailer.rb
class VerificationMailer < ApplicationMailer
  default from: ENV["EMAIL_USER"]

  def verify(user, token)
    @user = user
    @link = "#{ENV['APP_URL']}/verify-email?token=#{token}"
    mail(to: user.email, subject: "Verify your email")
  end
end
