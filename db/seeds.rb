# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Plan.find_or_create_by!(plan_type: 'free') do |p|
  p.name = 'Free'
  p.price = 0
  p.duration_hours = 0
  p.description = 'Normal product price'
  p.benefit = 'Normal product price'
  p.color = 'bg-gray-100'
  p.text_color = 'text-gray-800'
  p.popular = false
end

Plan.find_or_create_by!(plan_type: 'silver') do |p|
  p.name = 'Silver'
  p.price = 99
  p.duration_hours = 6
  p.description = '10% Discount on all products'
  p.benefit = '10% Discount on all products'
  p.color = 'bg-blue-50'
  p.text_color = 'text-blue-800'
  p.border_color = 'border-blue-200'
  p.popular = false
  # p.stripe_price_id = 'price_...' # Add if known
end

Plan.find_or_create_by!(plan_type: 'gold') do |p|
  p.name = 'Gold'
  p.price = 199
  p.duration_hours = 12
  p.description = '20% Discount on all products'
  p.benefit = '20% Discount on all products'
  p.color = 'bg-yellow-50'
  p.text_color = 'text-yellow-800'
  p.border_color = 'border-yellow-200'
  p.popular = true
  # p.stripe_price_id = 'price_...' # Add if known
end

puts "Plans seeded!"
