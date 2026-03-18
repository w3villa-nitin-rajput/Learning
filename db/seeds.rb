# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data to avoid duplicates
# db/seeds.rb

# Clear existing data (optional - be careful in production!)




puts "Creating subscription plans..."
plans = [
  {
    name: "Free",
    plan_type: "free",
    price: 0,
    duration_hours: nil, # Unlimited
    description: "Basic features for occasional food lovers",
    benefit: "✓ Standard delivery • Basic support • No product discounts",
    color: "#6B7280",
    border_color: "#E5E7EB",
    text_color: "#FFFFFF",
    popular: false,
  },
  {
    name: "Silver",
    plan_type: "silver",
    price: 99.00,
    duration_hours: 6,
    description: "Perfect for regular food enthusiasts - Get 10% discount on all products",
    benefit: "✓ Free delivery • Priority support • 10% discount on all products",
    color: "#94A3B8",
    border_color: "#64748B",
    text_color: "#FFFFFF",
    popular: false,
  },
  {
    name: "Gold",
    plan_type: "gold",
    price: 199.00,
    duration_hours: 12,
    description: "Ultimate experience for food connoisseurs - Get 20% discount on all products",
    benefit: "✓ Free delivery • 24/7 priority support • 20% discount on all products • Exclusive offers",
    color: "#FBBF24",
    border_color: "#B45309",
    text_color: "#1F2937",
    popular: true,
  }
]

created_plans = plans.map do |plan_data|
  Plan.create!(plan_data)
end
puts "Created #{Plan.count} plans"


puts "Admin login: admin@fooddelivery.com / password123"
