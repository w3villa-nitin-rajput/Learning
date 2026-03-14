class OrdersController < ApplicationController
  before_action :authorize_request

  def index
    @orders = current_user.orders.order(created_at: :desc)

    page     = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 10).to_i
    @orders  = @orders.page(page).per(per_page)

    render json: {
      orders: @orders.map { |o|
        {
          id: o.id,
          status: o.status,
          total: o.total,
          items: o.items,
          shipping_address: o.shipping_address,
          payment_method: o.payment_method,
          created_at: o.created_at
        }
      },
      meta: {
        current_page: @orders.current_page,
        total_pages:  @orders.total_pages,
        total_count:  @orders.total_count
      }
    }
  end

  def create_checkout_session
    cart_items = current_user.cart_items.includes(:product)
    
    if cart_items.empty?
      return render json: { error: "Cart is empty" }, status: :unprocessable_entity
    end

    line_items = cart_items.map do |item|
      product = item.product
      price = product.price_for_user(current_user)
      {
        price_data: {
          currency: 'inr',
          product_data: {
            name: product.name,
            images: product.image_urls.present? ? [product.image_urls.first] : []
          },
          unit_amount: (price * 100).to_i,
        },
        quantity: item.quantity,
      }
    end

    begin
      session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: line_items,
        mode: 'payment',
        success_url: "#{ENV['FRONTEND_URL']}/payment-success?session_id={CHECKOUT_SESSION_ID}&type=order",
        cancel_url: "#{ENV['FRONTEND_URL']}/cart",
        customer_email: current_user.email,
        metadata: {
          user_id: current_user.id,
          type: 'product_purchase',
          shipping_address: params[:address]
        }
      })

      render json: { checkout_url: session.url }, status: :ok
    rescue Stripe::StripeError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private

  def current_user
    @current_user
  end
end
