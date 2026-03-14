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
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
      puts "AUTHORIZATION ERROR for #{request.path}: #{e.message}" # DEBUG
      render json: { errors: e.message }, status: :unauthorized
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
