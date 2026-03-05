class ProductsController < ApplicationController
  skip_before_action :authorize_request, only: [:index]
  before_action :authorize_admin!, except: [:index]

def index
  # 2. Start with a base scope
  @products = Product.order(created_at: :desc)

  # 3. Apply filters using a chainable approach
  @products = @products.by_category(params[:category]) if params[:category].present?
  @products = @products.in_stock_only if params[:in_stock] == "true"
  @products = @products.search_by_term(params[:search]) if params[:search].present?

  # 4. Handle Pagination
  page = params[:page] || 1
  per_page = params[:per_page] || 10
  @products = @products.page(page).per(per_page)

  render json: {
    products: ::ProductSerializer.new(@products).serializable_hash[:data].map { |p| p[:attributes].merge(id: p[:id]) },
    meta: pagination_meta(@products)
  }
end

  def create
    product = Product.new(product_params)
    if product.save
      render json: product, status: :created
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    product = Product.find(params[:id])
    if product.update(product_params)
      render json: product
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    product = Product.find(params[:id])
    product.destroy
    head :no_content
  end

  private

  def authorize_admin!
    unless @current_user&.admin?
      render json: { error: 'Unauthorized: Admin access required' }, status: :forbidden
    end
  end

  def product_params
    params.require(:product).permit(:name, :category, :price, :offer_price, :in_stock, description: [], image_urls: [])
  end

  def pagination_meta(scoped_collection)
    {
      current_page: scoped_collection.current_page,
      total_pages: scoped_collection.total_pages,
      total_count: scoped_collection.total_count,
      per_page: scoped_collection.limit_value
    }
  end 

end
