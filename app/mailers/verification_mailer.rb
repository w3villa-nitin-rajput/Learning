# app/mailers/verification_mailer.rb
class VerificationMailer < ApplicationMailer
  

  def verify(user, token)
    @user = user
    @link = "#{ENV['FRONTEND_URL']}/verify?token=#{token}"
    mail(to: user.email, subject: "Verify your email")
  end
end
