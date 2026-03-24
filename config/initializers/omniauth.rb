# config/initializers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {
    scope: 'email, profile',
    prompt: 'select_account',
    image_aspect_ratio: 'square',
    image_size: 50
  }
  provider :facebook, ENV["FACEBOOK_CLIENT_ID"], ENV["FACEBOOK_CLIENT_SECRET"], scope: 'email,public_profile'
end
OmniAuth.config.allowed_request_methods = [ :get, :post ]
OmniAuth.config.logger = Rails.logger

# Debug: Print environment variables at startup
Rails.logger.info "GOOGLE_CLIENT_ID present: #{ENV['GOOGLE_CLIENT_ID'].present?}"
Rails.logger.info "GOOGLE_CLIENT_SECRET present: #{ENV['GOOGLE_CLIENT_SECRET'].present?}"
Rails.logger.info "FACEBOOK_CLIENT_ID present: #{ENV['FACEBOOK_CLIENT_ID'].present?}"
Rails.logger.info "FACEBOOK_CLIENT_SECRET present: #{ENV['FACEBOOK_CLIENT_SECRET'].present?}"
