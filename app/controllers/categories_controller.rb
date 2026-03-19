class CategoriesController < ApplicationController
  skip_before_action :authorize_request, only: [ :index ]
  before_action :authorize_admin!, except: [ :index ]

  def index
    categories = Category.all.order(:id)
    render json: CategorySerializer.new(categories).serializable_hash[:data].map { |c| c[:attributes].merge(id: c[:id]) }
  end

  def create
    category = Category.new(category_params)
    if category.save
      render json: CategorySerializer.new(category).serializable_hash[:data][:attributes].merge(id: category.id), status: :created
    else
      render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    category = Category.find(params[:id])
    old_public_id = category.cloudinary_public_id

    if category.update(category_params)
      # Delete old image if a new one was uploaded
      if category_params[:cloudinary_public_id].present? && old_public_id.present? && old_public_id != category_params[:cloudinary_public_id]
        category.delete_old_cloudinary_image
      end

      render json: CategorySerializer.new(category).serializable_hash[:data][:attributes].merge(id: category.id)
    else
      render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    category = Category.find(params[:id])

    # Delete image from Cloudinary before destroying category
    if category.cloudinary_public_id.present?
      category.delete_old_cloudinary_image
    end

    category.destroy
    head :no_content
  end

  private

  def authorize_admin!
    puts "[ADMIN AUTH] Checking admin access for user: #{@current_user&.id}"
    puts "[ADMIN AUTH] @current_user.present?: #{@current_user.present?}"
    puts "[ADMIN AUTH] @current_user.admin?: #{@current_user&.admin?}"
    puts "[ADMIN AUTH] @current_user role: #{@current_user&.role}"

    unless @current_user.present?
      puts "[ADMIN AUTH] ✗ User not authenticated"
      render json: {
        error: "User not authenticated",
        status: "unauthorized",
        message: "No authenticated user found"
      }, status: :unauthorized
      return
    end

    unless @current_user.admin?
      puts "[ADMIN AUTH] ✗ User is not admin (role: #{@current_user.role})"
      render json: {
        error: "Unauthorized: Admin access required",
        user_id: @current_user.id,
        user_email: @current_user.email,
        user_role: @current_user.role,
        status: "forbidden",
        message: "User #{@current_user.email} is not an admin"
      }, status: :forbidden
      return
    end
    puts "[ADMIN AUTH] ✓ Admin access granted for #{@current_user.email}"
  end

  def category_params
    params.require(:category).permit(:name, :path, :image_url, :bg_color, :cloudinary_url, :cloudinary_public_id)
  end
end
