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
puts "Cleaning database..."
CartItem.destroy_all
Order.destroy_all
Product.destroy_all
Category.destroy_all
User.destroy_all
Plan.destroy_all

# 1. Create Plans
puts "Creating Plans..."
plans = [
  { name: 'Free', plan_type: 'free', price: 0, benefit: 'Basic Access', color: 'gray', border_color: 'gray-200', text_color: 'black', duration_hours: 0, popular: false },
  { name: 'Silver', plan_type: 'silver', price: 19.99, benefit: '10% Discount on all items', color: 'blue', border_color: 'blue-300', text_color: 'blue-700', duration_hours: 720, popular: true },
  { name: 'Gold', plan_type: 'gold', price: 49.99, benefit: 'Priority Support & 20% Discount', color: 'gold', border_color: 'yellow-500', text_color: 'yellow-900', duration_hours: 720, popular: false }
]

created_plans = plans.map { |plan_data| Plan.create!(plan_data) }
free_plan = created_plans.find { |p| p.name == 'Free' }

# 2. Create Admin User
puts "Creating Admin..."
User.create!(
  name: "Admin User",
  email: "admin@zepto.com",
  password: "password123", # Assumes has_secure_password
  role: 1, # Adjust based on your enum (usually 1 is admin)
  email_verified: true,
  plan_id: free_plan.id
)

# 3. Create Categories
puts "Creating Categories..."
categories_data = [
  { name: "Electronics", path: "electronics", bg_color: "#E3F2FD" },
  { name: "Clothing", path: "clothing", bg_color: "#F3E5F5" },
  { name: "Home & Garden", path: "home-garden", bg_color: "#E8F5E9" },
  { name: "Books", path: "books", bg_color: "#FFF3E0" },
  { name: "Beauty", path: "beauty", bg_color: "#FCE4EC" },
  { name: "Sports", path: "sports", bg_color: "#E0F2F1" }
]

created_categories = categories_data.map { |cat| Category.create!(cat) }

# 4. Create 30 Products
puts "Creating 30 Products..."
30.times do |i|
  category = created_categories.sample
  price = rand(10.0..500.0).round(2)
  
  Product.create!(
    name: "Premium #{category.name} Item #{i + 1}",
    category: category.name,
    description: ["High quality material", "Durable design", "Customer favorite"],
    price: price,
    offer_price: price * 0.8, # 20% off
    in_stock: true,
    image_urls: ["https://picsum.photos/seed/#{i}/400/400"]
  )
end

puts "Seed complete!"
puts "Created: #{Plan.count} Plans, #{User.count} Admin, #{Category.count} Categories, #{Product.count} Products."