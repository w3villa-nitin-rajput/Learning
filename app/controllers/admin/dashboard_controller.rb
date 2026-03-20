class Admin::DashboardController < AdminController
  def stats
    begin
      # 1. Fetching stats with a default of 0 if nil
      users_count = User.count
      products_count = Product.count
      orders_count = Order.count
      revenue = Order.sum(:total) || 0

      # 2. Efficiently fetching recent orders
      recent_orders = Order.includes(:user).order(created_at: :desc).limit(5)
      
      # 3. Serializing data
      # Note: I simplified the user mapping to avoid manual ID matching
      serialized_orders = recent_orders.map do |order|
        {
          id: order.id,
          total: order.total,
          status: order.status,
          created_at: order.created_at,
          user: {
            id: order.user&.id,
            name: order.user&.name || "Unknown User",
            email: order.user&.email
          }
        }
      end

      render json: {
        success: true,
        stats: {
          users: users_count,
          products: products_count,
          orders: orders_count,
          revenue: revenue
        },
        recent_orders: serialized_orders
      }, status: :ok

    rescue StandardError => e
      # 4. Log the actual error for debugging
      Rails.logger.error "Dashboard Stats Error: #{e.message}"
      
      render json: {
        success: false,
        error: "Failed to load dashboard statistics",
        message: e.message # Remove e.message in production for security
      }, status: :internal_server_error
    end
  end
end