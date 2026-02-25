class AuthController < ApplicationController
  skip_before_action :authorize_request


  # Standard Signup
  def signup
    user = User.create(user_params)

    if user.persisted?
      send_verification_email(user)
      render json: { message: "Signup successful. Check email to verify." }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Login
  def login
    user = User.find_by(email: params[:email])  

    if user&.authenticate(params[:password])
      return render json: { error: "Verify your email first" }, status: 403 unless user.email_verified?

      token = JwtService.encode(user_id: user.id)

      render json: { token: token }
    else
      render json: { error: "Invalid credentials" }, status: 401
    end
  end

  # Email Verification
  def verify_email
    decoded = JwtService.decode(params[:token])
    return render json: { error: "Invalid link" }, status: 400 unless decoded

    user = User.find_by(email: decoded[:email])
    return render json: { error: "User not found" }, status: 404 unless user

    user.update(email_verified: true)
    render json: { message: "Email verified successfully" }
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

  def send_verification_email(user)
    token = JwtService.encode({ email: user.email }, 1.day.from_now)
    VerificationMailer.verify(user, token).deliver_later
  end
end
