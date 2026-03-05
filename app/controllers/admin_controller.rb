class AdminController < ApplicationController
  before_action :authorize_admin!

  private

  def authorize_admin!
    unless @current_user&.admin?
      render json: { error: 'Unauthorized: Admin access required' }, status: :forbidden
    end
  end
end
