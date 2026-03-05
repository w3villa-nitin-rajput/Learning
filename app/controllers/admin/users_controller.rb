class Admin::UsersController < AdminController
  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    
    users = User.order(created_at: :desc).page(page).per(per_page)
    
    render json: {
      users: UserSerializer.new(users).serializable_hash[:data].map { |u| u[:attributes].merge(id: u[:id]) },
      meta: {
        current_page: users.current_page,
        total_pages: users.total_pages,
        total_count: users.total_count
      }
    }
  end

  def show
    user = User.find(params[:id])
    render json: UserSerializer.new(user).serializable_hash[:data][:attributes].merge(id: user.id)
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: UserSerializer.new(user).serializable_hash[:data][:attributes].merge(id: user.id)
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:role, :email_verified)
  end
end
