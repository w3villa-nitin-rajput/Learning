class CategoriesController < ApplicationController
  skip_before_action :authorize_request, only: [:index]
  before_action :authorize_admin!, except: [:index]

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
    if category.update(category_params)
      render json: CategorySerializer.new(category).serializable_hash[:data][:attributes].merge(id: category.id)
    else
      render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    category = Category.find(params[:id])
    category.destroy
    head :no_content
  end

  private

  def authorize_admin!
    unless @current_user&.admin?
      render json: { error: 'Unauthorized: Admin access required' }, status: :forbidden
    end
  end

  def category_params
    params.require(:category).permit(:name, :path, :image_url, :bg_color)
  end
end
