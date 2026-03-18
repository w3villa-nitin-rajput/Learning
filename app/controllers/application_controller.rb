class ApplicationController < ActionController::API
  before_action :authorize_request
  attr_accessor :current_user
  
  private

  def authorize_request
    header = request.headers['Authorization']
    # puts "AUTHORIZATION HEADER: #{header}" # DEBUG
    header = header.split(' ').last if header
    
    begin
      raise JWT::DecodeError, 'Missing token' unless header.present?
      @decoded = JwtService.decode(header)
      
      if @decoded.nil?
        render json: { errors: "Invalid or expired token" }, status: :unauthorized
        return
      end

      user_id = @decoded[:user_id]
      @current_user = User.find_by(id: user_id)
      
      unless @current_user
        raise ActiveRecord::RecordNotFound, "Couldn't find User with 'id'=#{user_id} (Token might be stale after DB reset)"
      end
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
      puts "AUTHORIZATION ERROR for #{request.path}: #{e.message}" # DEBUG
      render json: { errors: e.message }, status: :unauthorized
    rescue StandardError => e
      puts "CRITICAL AUTHORIZATION ERROR: #{e.message}"
      render json: { errors: "Authentication failed" }, status: :unauthorized
    end
  end

  def set_current_user
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    return unless header.present?

    begin
      @decoded = JwtService.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      @current_user = nil
    end
  end
end
