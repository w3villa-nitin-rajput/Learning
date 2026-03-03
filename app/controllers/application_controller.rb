class ApplicationController < ActionController::API
  before_action :authorize_request
  attr_accessor :current_user
  
  private

  def authorize_request
    # This looks for the "Authorization" header
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    
    begin
      @decoded = JwtService.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { errors: 'Unauthorized' }, status: :unauthorized
    end
  end
end
