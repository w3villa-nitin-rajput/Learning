class ApplicationController < ActionController::API
  before_action :authorize_request
  attr_accessor :current_user

  private

  def authorize_request
    header = request.headers["Authorization"]
    puts "[AUTHORIZATION] Endpoint: #{request.path} | Header present: #{header.present?}"
    header = header.split(" ").last if header

    begin
      raise JWT::DecodeError, "Missing token" unless header.present?

      @decoded = JwtService.decode(header)
      puts "[AUTHORIZATION] Decoded token: #{@decoded.inspect}"

      if @decoded.nil?
        render json: { errors: "Invalid or expired token", status: "unauthorized" }, status: :unauthorized
        return
      end

      user_id = @decoded[:user_id]
      puts "[AUTHORIZATION] Looking up user_id: #{user_id}"

      @current_user = User.find_by(id: user_id)
      puts "[AUTHORIZATION] Found user: #{@current_user&.email} | Role: #{@current_user&.role}"

      unless @current_user
        raise ActiveRecord::RecordNotFound, "User with id=#{user_id} not found. Token might be stale."
      end

      puts "[AUTHORIZATION] ✓ User authenticated: #{@current_user.email} (#{@current_user.role})"
    rescue JWT::DecodeError => e
      puts "[AUTHORIZATION ERROR] JWT decode error for #{request.path}: #{e.message}"
      render json: { errors: "Invalid token: #{e.message}", status: "unauthorized" }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound => e
      puts "[AUTHORIZATION ERROR] User not found for #{request.path}: #{e.message}"
      render json: { errors: e.message, status: "unauthorized" }, status: :unauthorized
    rescue StandardError => e
      puts "[CRITICAL AUTHORIZATION ERROR] #{e.class} - #{e.message}"
      render json: { errors: "Authentication failed: #{e.message}", status: "internal_error" }, status: :internal_server_error
    end
  end

  def set_current_user
    header = request.headers["Authorization"]
    header = header.split(" ").last if header
    return unless header.present?

    begin
      @decoded = JwtService.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      @current_user = nil
    end
  end
end
