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




# db/seeds.rb

# Clear existing data (optional - be careful in production!)
CartItem.destroy_all
Order.destroy_all
Product.destroy_all
Category.destroy_all
Plan.destroy_all
User.destroy_all

puts "Creating Admin..."

admin = User.create!(
  name: "Admin",
  email: "admin@example.com",
  password: "password123",
  role: "admin"
)

puts "Admin created: #{admin.email}"


puts "Creating plans..."

Plan.create!([
  {
    name: "Free",
    plan_type: "free",
    price: 0,
    duration_hours: 0,
    description: "Default free plan",
    benefit: "No discount",
    color: "#9CA3AF",
    border_color: "#9CA3AF",
    text_color: "#000",
    popular: false
  },
  {
    name: "Silver",
    plan_type: "silver",
    price: 499,
    duration_hours: 6, # 30 days
    description: "Silver membership plan",
    benefit: "10% discount on all products",
    color: "#C0C0C0",
    border_color: "#9CA3AF",
    text_color: "#000",
    popular: true
  },
  {
    name: "Gold",
    plan_type: "gold",
    price: 999,
    duration_hours: 12,
    description: "Gold membership plan",
    benefit: "20% discount on all products",
    color: "#FFD700",
    border_color: "#FBBF24",
    text_color: "#000",
    popular: false
  }
])


# puts "Creating categories..."

# categories = [
#   {
#     name: "Pizza",
#     path: "pizza",
#     bg_color: "#FEF3C7",
#     image_url: "https://images.unsplash.com/photo-1601924638867-3ec2b0c3c7a4"
#   },
#   {
#     name: "Burgers",
#     path: "burgers",
#     bg_color: "#FEE2E2",
#     image_url: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd"
#   },
#   {
#     name: "Sushi",
#     path: "sushi",
#     bg_color: "#D1FAE5",
#     image_url: "https://images.unsplash.com/photo-1579871494447-9811cf80d66c"
#   },
#   {
#     name: "Chinese",
#     path: "chinese",
#     bg_color: "#FFEDD5",
#     image_url: "https://images.unsplash.com/photo-1585032226651-759b368d7246"
#   },
#   {
#     name: "Desserts",
#     path: "desserts",
#     bg_color: "#FCE7F3",
#     image_url: "https://images.unsplash.com/photo-1551024601-bec78aea704b"
#   },
#   {
#     name: "Beverages",
#     path: "beverages",
#     bg_color: "#DBEAFE",
#     image_url: "https://images.unsplash.com/photo-1544145945-f90425340c7e"
#   }
# ]

# categories.each do |data|
#   Category.create!(data)
# end

# puts "Created #{Category.count} categories"


# def get_product_image(category, index)

#   image_map = {

#     pizza: [
#       "https://images.unsplash.com/photo-1594007654729-407eedc4be65",
#       "https://images.unsplash.com/photo-1513104890138-7c749659a591",
#       "https://images.unsplash.com/photo-1548365328-9f547fb0953d"
#     ],

#     burgers: [
#       "https://images.unsplash.com/photo-1568901346375-23c9450c58cd",
#       "https://images.unsplash.com/photo-1550547660-d9450f859349",
#       "https://images.unsplash.com/photo-1550317138-10000687a72b"
#     ],

#     sushi: [
#       "https://images.unsplash.com/photo-1579871494447-9811cf80d66c",
#       "https://images.unsplash.com/photo-1553621042-f6e147245754",
#       "https://images.unsplash.com/photo-1617196034183-421b4917c92d"
#     ],

#     chinese: [
#       "https://images.unsplash.com/photo-1585032226651-759b368d7246",
#       "https://images.unsplash.com/photo-1603133872878-684f208fb84b",
#       "https://images.unsplash.com/photo-1604908176997-125f25cc6f3d"
#     ],

#     desserts: [
#       "https://images.unsplash.com/photo-1551024601-bec78aea704b",
#       "https://images.unsplash.com/photo-1589308078059-be1415eab4c3",
#       "https://images.unsplash.com/photo-1578985545062-69928b1d9587"
#     ],

#     beverages: [
#       "https://images.unsplash.com/photo-1544145945-f90425340c7e",
#       "https://images.unsplash.com/photo-1551024709-8f23befc6f87",
#       "https://images.unsplash.com/photo-1497534446932-c925b458314e"
#     ]
#   }

#   images = image_map[category.to_sym]
#   images[index % images.length]

# end


# products = [

# # Pizza
# {
# name: "Margherita Pizza",
# category: "pizza",
# price: 250,
# offer_price: 200,
# description: ["Tomato sauce","Mozzarella","Basil"],
# in_stock: true,
# image_urls: [get_product_image("pizza",0)]
# },

# {
# name: "Pepperoni Pizza",
# category: "pizza",
# price: 300,
# offer_price: 260,
# description: ["Pepperoni","Cheese","Italian herbs"],
# in_stock: true,
# image_urls: [get_product_image("pizza",1)]
# },

# {
# name: "Veggie Pizza",
# category: "pizza",
# price: 280,
# offer_price: 230,
# description: ["Onions","Capsicum","Olives"],
# in_stock: true,
# image_urls: [get_product_image("pizza",2)]
# },

# # Burgers
# {
# name: "Classic Burger",
# category: "burgers",
# price: 180,
# offer_price: 150,
# description: ["Beef patty","Cheese","Lettuce"],
# in_stock: true,
# image_urls: [get_product_image("burgers",0)]
# },

# {
# name: "Chicken Burger",
# category: "burgers",
# price: 200,
# offer_price: 170,
# description: ["Chicken patty","Mayo","Tomato"],
# in_stock: true,
# image_urls: [get_product_image("burgers",1)]
# },

# # Sushi
# {
# name: "California Roll",
# category: "sushi",
# price: 320,
# offer_price: 280,
# description: ["Crab","Avocado","Rice"],
# in_stock: true,
# image_urls: [get_product_image("sushi",0)]
# },

# {
# name: "Salmon Sushi",
# category: "sushi",
# price: 350,
# offer_price: 300,
# description: ["Fresh salmon","Rice"],
# in_stock: true,
# image_urls: [get_product_image("sushi",1)]
# },

# # Chinese
# {
# name: "Fried Rice",
# category: "chinese",
# price: 200,
# offer_price: 170,
# description: ["Rice","Vegetables","Egg"],
# in_stock: true,
# image_urls: [get_product_image("chinese",0)]
# },

# {
# name: "Spring Rolls",
# category: "chinese",
# price: 150,
# offer_price: 120,
# description: ["Crispy rolls","Veg filling"],
# in_stock: true,
# image_urls: [get_product_image("chinese",1)]
# },

# # Desserts
# {
# name: "Chocolate Cake",
# category: "desserts",
# price: 180,
# offer_price: 150,
# description: ["Chocolate","Cream"],
# in_stock: true,
# image_urls: [get_product_image("desserts",0)]
# },

# # Beverages
# {
# name: "Orange Juice",
# category: "beverages",
# price: 120,
# offer_price: 100,
# description: ["Fresh juice"],
# in_stock: true,
# image_urls: [get_product_image("beverages",0)]
# },

# {
# name: "Milkshake",
# category: "beverages",
# price: 150,
# offer_price: 120,
# description: ["Milk","Ice cream"],
# in_stock: true,
# image_urls: [get_product_image("beverages",1)]
# }

# ]


# products.each do |product_data|

# category = Category.find_by(path: product_data[:category])

# Product.create!(
#   name: product_data[:name],
#   price: product_data[:price],
#   offer_price: product_data[:offer_price],
#   description: product_data[:description],
#   in_stock: product_data[:in_stock],
#   image_urls: product_data[:image_urls],
#   category_id: category.id
# )

# end

# puts "Created #{Product.count} products"


# puts "Admin login: admin@fooddelivery.com / password123"
