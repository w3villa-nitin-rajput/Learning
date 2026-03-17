class AuthController < ApplicationController
  before_action :authorize_request, only: [:get_user_profile]


  # Standard Signup
  # def signup
  #   User.transaction do
  #     @user = User.new(user_params)
  #     if @user.save
  #       send_verification_email(@user)
  #       render json: { message: "Signup successful. Check email." }, status: :created
  #     else
  #       render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
  #     end
  #   end
  #   rescue StandardError => e
  #     render json: { error: "Email could not be sent. Please check your email address." }, status: :internal_server_error
  # end 

  # app/controllers/auth_controller.rb
def signup
  User.transaction do
    @user = User.new(user_params)
    if @user.save
      send_verification_email(@user)
      render json: { message: "Signup successful. Check email." }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end
rescue => e
  # THIS LINE IS CRITICAL - It forces the error into your Render Logs
  puts "!!! EMAIL SENDING FAILED: #{e.message} !!!"
  puts "DEBUG: API Key present? #{ENV['RESEND_API_KEY']&.first(5)}..."
  Rails.logger.error "Full Email Error: #{e.backtrace.first(5).join("\n")}"
  
  render json: { error: "Email could not be sent. Check logs." }, status: :internal_server_error
end

  # Login
def login
  user = User.find_by(email: params[:email])

  if user&.authenticate(params[:password])
    # Add this check to enforce verification
    return render json: { error: "Please verify your email first" }, status: :forbidden unless user.email_verified

    token = JwtService.encode(user_id: user.id)
    render json: { token: token }
  else
    render json: { error: "Invalid credentials" }, status: :unauthorized
  end
end


  # Email Verification
def verify_email
  decoded = JwtService.decode(params[:token])
  
  if decoded.nil?
    return render json: { error: "Invalid or expired verification link" }, status: :unauthorized
  end

  user = User.find_by(email: decoded[:email])
  
  if user
    user.update(email_verified: true) unless user.email_verified
    render json: {success: true, message: "Email verified successfully!"}
  else
    render json: {success: false, message: "User not found"}
  end
rescue StandardError => e
  render json: {success: false, message: "Something went wrong"}
end



def resend_verification_email
  user = User.find_by(email: params[:email])
  return render json: { error: "User not found" }, status: :not_found unless user

  if user && !user.email_verified
    send_verification_email(user)
    render json: { message: "Verification email sent successfully" }, status: :ok
  else
    render json: { error: "User not found or already verified" }, status: :bad_request
  end
end

def get_user_profile
  user = User.find_by(id: @current_user.id)
  puts "user: #{user}"
  if user
    render json: ::UserSerializer.new(user).serializable_hash[:data][:attributes].merge(id: user.id)
  else
    render json: { error: "User not found" }, status: :not_found
  end
end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

  def send_verification_email(user)
    payload = { email: user.email, exp: 1.day.from_now.to_i }
    token = JwtService.encode(payload)
    VerificationMailer.verify(user, token).deliver_now
  end
end
