class Admin::DashboardController < AdminController
  def stats
    users_count = User.count
    products_count = Product.count
    orders_count = Order.count
    revenue = Order.sum(:total)

    recent_orders = Order.includes(:user).order(created_at: :desc).limit(5)
    serialized_orders = OrderSerializer.new(recent_orders, include: [:user]).serializable_hash[:data].map do |o|
      user_id = o[:relationships][:user][:data][:id]
      user = recent_orders.find { |ro| ro.id.to_s == user_id.to_s }.user
      o[:attributes].merge(
        id: o[:id],
        user: { id: user.id, name: user.name, email: user.email }
      )
    end

    render json: {
      stats: {
        users: users_count,
        products: products_count,
        orders: orders_count,
        revenue: revenue
      },
      recent_orders: serialized_orders
    }
  end
end
