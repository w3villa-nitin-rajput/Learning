class SocialAuthController < ApplicationController
  skip_before_action :authorize_request
  def callback
    auth = request.env["omniauth.auth"]

    email = auth.info.email&.strip&.downcase
    provider = auth.provider
    uid = auth.uid

    unless email
      frontend_url = ENV['FRONTEND_URL'] || "http://localhost:5173"
      redirect_to "#{frontend_url.chomp('/')}/?error=email_required", allow_other_host: true
      return
    end

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
    
    frontend_url = ENV['FRONTEND_URL'] || "http://localhost:5173"
    # Ensure there is exactly one / between URL and ?token
    base_url = frontend_url.chomp('/')
    redirect_url = "#{base_url}/?token=#{token}"
    
    puts "Social Auth Debug: Final Redirect URL: #{redirect_url.sub(token, '[FILTERED]')}"
    redirect_to redirect_url, allow_other_host: true
  rescue StandardError => e
    puts "Social Auth CRITICAL ERROR: #{e.message}\n#{e.backtrace.join("\n")}"
    redirect_to (ENV['FRONTEND_URL'] || "http://localhost:5173"), allow_other_host: true
  end
end
