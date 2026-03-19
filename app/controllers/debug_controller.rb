class DebugController < ApplicationController
  skip_before_action :authorize_request, only: [:health]
  before_action :authorize_request, except: [:health]

  def health
    render json: { 
      status: 'ok',
      environment: Rails.env,
      timestamp: Time.current,
      solid_queue_in_puma: ENV.fetch('SOLID_QUEUE_IN_PUMA', 'not set')
    }
  end

  def auth_debug
    render json: {
      current_user: {
        id: @current_user&.id,
        email: @current_user&.email,
        role: @current_user&.role,
        is_admin: @current_user&.admin?,
        authenticated: @current_user.present?
      },
      token_decoded: @decoded.inspect,
      authorization_header: request.headers['Authorization'].present? ? 'present' : 'missing'
    }
  end

  def admin_test
    puts "[DEBUG] Testing admin authorization"
    puts "[DEBUG]   Current user: #{@current_user&.email}"
    puts "[DEBUG]   Is admin: #{@current_user&.admin?}"
    
    render json: {
      message: 'Admin access successful',
      user: {
        id: @current_user.id,
        email: @current_user.email,
        role: @current_user.role,
        is_admin: @current_user.admin?
      }
    }
  end

  def image_upload_debug
    user = @current_user
    render json: {
      cloudinary_config: {
        cloud_name: ENV.fetch('CLOUDINARY_CLOUD_NAME', 'not set'),
        api_key_present: ENV.fetch('CLOUDINARY_API_KEY', '').present?,
        api_secret_present: ENV.fetch('CLOUDINARY_API_SECRET', '').present?
      },
      user_image_data: {
        cloudinary_url: user.cloudinary_url,
        cloudinary_public_id: user.cloudinary_public_id,
        image_present: user.cloudinary_url.present?
      },
      cors_config: {
        frontend_url: ENV.fetch('FRONTEND_URL', 'not set'),
        allowed_origins: [
          'http://localhost:5173',
          ENV.fetch('FRONTEND_URL', '').delete_suffix('/') if ENV["FRONTEND_URL"].present?
        ].compact
      },
      test_cloudinary_url: "https://res.cloudinary.com/#{ENV['CLOUDINARY_CLOUD_NAME']}/image/upload/sample.jpg"
    }
  end
end
