class SocialAuthController < ApplicationController
  skip_before_action :authorize_request
  def callback
    auth = request.env["omniauth.auth"]

    email = auth.info.email.strip.downcase
    provider = auth.provider
    uid = auth.uid

    puts "Social Auth Debug: Provider=#{provider}, UID=#{uid}, Email=#{email}"

    user = User.find_by(email: email)

    if user
      puts "Social Auth Debug: Found existing user with ID=#{user.id}. Merging..."
      unless user.update("#{provider}_uid": uid, email_verified: true)
        puts "Social Auth Debug: Update failed! Errors: #{user.errors.full_messages}"
      end
    else
      puts "Social Auth Debug: No user found. Creating new user..."
      user = User.create!(
        name: auth.info.name,
        email: email,
        password: SecureRandom.hex(10),
        email_verified: true,
        "#{provider}_uid": uid
      )
      puts "Social Auth Debug: Created user with ID=#{user.id}"
    end

    token = JwtService.encode(user_id: user.id)
    puts "Social Auth Debug: Redirecting to #{ENV['FRONTEND_URL']}/?token=[FILTERED] for User ID=#{user.id}"
    redirect_to "#{ENV['FRONTEND_URL']}/?token=#{token}", allow_other_host: true
  end
end
