class ApplicationController < ActionController::API
  before_action :authorize_request

  private

  def authorize_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    decoded = JwtService.decode(token)
    @current_user = User.find(decoded[:user_id]) if decoded
  rescue
    render json: { error: "Unauthorized" }, status: 401
  end
end
