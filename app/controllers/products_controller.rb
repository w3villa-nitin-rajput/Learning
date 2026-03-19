class ProductsController < ApplicationController
  skip_before_action :authorize_request, only: [ :index, :show ]
  before_action :set_current_user, only: [ :index, :show ]
  before_action :authorize_admin!, except: [ :index, :show ]

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
      products: @products.map { |product|
        # Use the serializer for standard fields
        data = ::ProductSerializer.new(product).serializable_hash[:data][:attributes]

        # Add the ID and the dynamic price without hitting the DB again
        data.merge(
          id: product.id,
          discounted_price: product.price_for_user(@current_user)
        )
      },
      meta: pagination_meta(@products)
    }
  end

  def show
    product = Product.find(params[:id])
    data = ::ProductSerializer.new(product).serializable_hash[:data][:attributes]
    render json: data.merge(
      id: product.id,
      discounted_price: product.price_for_user(@current_user)
    )
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Product not found" }, status: :not_found
  end

  def create
    product = Product.new(product_params)
    if product.save
      render json: ::ProductSerializer.new(product).serializable_hash[:data][:attributes].merge(id: product.id), status: :created
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    product = Product.find(params[:id])
    old_public_id = product.cloudinary_public_id

    if product.update(product_params)
      # Delete old image if a new one was uploaded
      if product_params[:cloudinary_public_id].present? && old_public_id.present? && old_public_id != product_params[:cloudinary_public_id]
        product.delete_old_cloudinary_image
      end

      render json: ::ProductSerializer.new(product).serializable_hash[:data][:attributes].merge(id: product.id)
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    product = Product.find(params[:id])

    # Delete image from Cloudinary before destroying product
    if product.cloudinary_public_id.present?
      product.delete_old_cloudinary_image
    end

    product.destroy
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

  def product_params
    params.require(:product).permit(:name, :category, :price, :offer_price, :in_stock, :cloudinary_url, :cloudinary_public_id, description: [], image_urls: [])
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
