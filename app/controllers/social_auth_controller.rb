class SocialAuthController < ApplicationController
  skip_before_action :authorize_request
  def callback
    auth = request.env["omniauth.auth"]

    email = auth.info.email
    provider = auth.provider
    uid = auth.uid

    user = User.find_by(email: email)

    if user
      user.update("#{provider}_uid": uid)
    else
      user = User.create!(
        name: auth.info.name,
        email: email,
        password: SecureRandom.hex(10),
        email_verified: true,
        "#{provider}_uid": uid
      )
    end

    token = JwtService.encode(user_id: user.id)
    redirect_to "#{ENV['FRONTEND_URL']}/?token=#{token}", allow_other_host: true
  end
end
