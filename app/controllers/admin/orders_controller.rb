class Admin::OrdersController < AdminController
  def index
    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 10).to_i

    orders = Order.includes(:user).order(created_at: :desc)
    orders = orders.where(status: params[:status]) if params[:status].present?

    paginated_orders = orders.page(page).per(per_page)
    
    serialized_orders = OrderSerializer.new(paginated_orders, include: [:user]).serializable_hash[:data].map do |o|
      user_id = o[:relationships][:user][:data][:id]
      user = paginated_orders.find { |po| po.id.to_s == user_id.to_s }.user
      o[:attributes].merge(
        id: o[:id],
        user: { id: user.id, name: user.name, email: user.email }
      )
    end

    render json: {
      orders: serialized_orders,
      meta: {
        current_page: paginated_orders.current_page,
        total_pages: paginated_orders.total_pages,
        total_count: paginated_orders.total_count
      }
    }
  end

  def show
    order = Order.includes(:user).find(params[:id])
    serialized_order = OrderSerializer.new(order, include: [:user]).serializable_hash[:data]
    user = order.user
    render json: serialized_order[:attributes].merge(
      id: serialized_order[:id],
      user: { id: user.id, name: user.name, email: user.email }
    )
  end

  def update
    order = Order.find(params[:id])
    if order.update(order_params)
      render json: OrderSerializer.new(order).serializable_hash[:data][:attributes].merge(id: order.id)
    else
      render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(:status, :payment_status)
  end
end
