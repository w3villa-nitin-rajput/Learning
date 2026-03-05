class CartsController < ApplicationController
  before_action :authorize_request

  # GET /cart
  def index
    cart_items = @current_user.cart_items.includes(:product)
    render json: { 
      cartItems: serialize_cart_items(cart_items)
    }
  end

  # POST /cart/add
  def add
    product = Product.find(params[:product_id])
    cart_item = @current_user.cart_items.find_or_initialize_by(product_id: product.id)
    cart_item.quantity = (cart_item.quantity || 0) + 1
    
    if cart_item.save
      render json: { message: "Item added to cart", cartItems: cart_hash }
    else
      render json: { errors: cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /cart/update
  def update
    cart_item = @current_user.cart_items.find_by(product_id: params[:product_id])
    
    if cart_item
      quantity = params[:quantity].to_i
      if quantity <= 0
        cart_item.destroy
      else
        cart_item.update(quantity: quantity)
      end
      render json: { message: "Cart updated", cartItems: cart_hash }
    else
      render json: { error: "Item not found in cart" }, status: :not_found
    end
  end

  private

  def cart_hash
    serialize_cart_items(@current_user.cart_items)
  end

  def serialize_cart_items(cart_items)
    CartItemSerializer.new(cart_items).serializable_hash[:data].each_with_object({}) do |item, hash|
      hash[item[:attributes][:product_id]] = item[:attributes][:quantity]
    end
  end
end
