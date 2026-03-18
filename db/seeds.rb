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
puts "Cleaning database..."
CartItem.destroy_all
Product.destroy_all
Category.destroy_all
Plan.destroy_all
User.destroy_all


puts "Creating admin user..."
admin = User.create!(
  email: "admin@fooddelivery.com",
  password: "password123",
  password_confirmation: "password123",
  name: "Admin User",
  role: 1, # Assuming 1 is admin role
  address: "123 Admin Street, Food City",
  email_verified: true
)
puts "Admin created: #{admin.email}"

User.create!(
  email: "nitinrajput824859@gmail.com",
  password: "password123",
  password_confirmation: "password123",
  name: "User",
  role: 0, # Assuming 1 is admin role
  address: "123 Admin Street, Food City",
  email_verified: true
)

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
    price: 99,
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
    price: 199,
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

puts "Creating categories with transparent PNGs..."
categories = [
  {
    name: "Pizza",
    path: "pizza",
    bg_color: "#FEF3C7",
    image_url: "https://pngimg.com/uploads/pizza/pizza_PNG44095.png"
  },
  {
    name: "Burgers",
    path: "burgers",
    bg_color: "#FEE2E2",
    image_url: "https://pngimg.com/uploads/burger/burger_PNG4135.png"
  },
  {
    name: "Sushi",
    path: "sushi",
    bg_color: "#D1FAE5",
    image_url: "https://pngimg.com/uploads/sushi/sushi_PNG9260.png"
  },
  {
    name: "Chinese",
    path: "chinese",
    bg_color: "#FFEDD5",
    image_url: "https://pngimg.com/uploads/noodles/noodles_PNG36.png"
  },
  {
    name: "Desserts",
    path: "desserts",
    bg_color: "#FCE7F3",
    image_url: "https://pngimg.com/uploads/cake/cake_PNG13127.png"
  },
  {
    name: "Beverages",
    path: "beverages",
    bg_color: "#DBEAFE",
    image_url: "https://pngimg.com/uploads/juice/juice_PNG7154.png"
  }
]

created_categories = categories.map do |category_data|
  Category.create!(category_data)
end
puts "Created #{Category.count} categories"

puts "Creating food products with transparent PNGs..."
def get_product_image(category, index)
  image_map = {
    pizza: [
      "https://pngimg.com/uploads/pizza/pizza_PNG44095.png",
      "https://pngimg.com/uploads/pizza/pizza_PNG44071.png",
      "https://pngimg.com/uploads/pizza/pizza_PNG44083.png",
      "https://pngimg.com/uploads/pizza/pizza_PNG44088.png",
      "https://pngimg.com/uploads/pizza/pizza_PNG43985.png",
      "https://pngimg.com/uploads/pizza/pizza_PNG43978.png"
    ],
    burgers: [
      "https://pngimg.com/uploads/burger/burger_PNG4135.png",
      "https://pngimg.com/uploads/burger/burger_PNG4138.png",
      "https://pngimg.com/uploads/burger/burger_PNG4141.png",
      "https://pngimg.com/uploads/burger/burger_PNG4143.png",
      "https://pngimg.com/uploads/burger/burger_PNG4145.png",
      "https://pngimg.com/uploads/burger/burger_PNG4148.png"
    ],
    sushi: [
      "https://pngimg.com/uploads/sushi/sushi_PNG9260.png",
      "https://pngimg.com/uploads/sushi/sushi_PNG9248.png",
      "https://pngimg.com/uploads/sushi/sushi_PNG9253.png",
      "https://pngimg.com/uploads/sushi/sushi_PNG9256.png",
      "https://pngimg.com/uploads/sushi/sushi_PNG9263.png"
    ],
    chinese: [
      "https://pngimg.com/uploads/noodles/noodles_PNG36.png",
      "https://pngimg.com/uploads/noodles/noodles_PNG28.png",
      "https://pngimg.com/uploads/noodles/noodles_PNG20.png",
      "https://pngimg.com/uploads/noodles/noodles_PNG17.png",
      "https://pngimg.com/uploads/noodles/noodles_PNG11.png"
    ],
    desserts: [
      "https://pngimg.com/uploads/cake/cake_PNG13127.png",
      "https://pngimg.com/uploads/cake/cake_PNG13101.png",
      "https://pngimg.com/uploads/cake/cake_PNG13096.png",
      "https://pngimg.com/uploads/ice_cream/ice_cream_PNG5100.png",
      "https://pngimg.com/uploads/ice_cream/ice_cream_PNG5106.png"
    ],
    beverages: [
      "https://pngimg.com/uploads/juice/juice_PNG7154.png",
      "https://pngimg.com/uploads/juice/juice_PNG7160.png",
      "https://pngimg.com/uploads/coffee/coffee_PNG16802.png",
      "https://pngimg.com/uploads/milkshake/milkshake_PNG53.png",
      "https://pngimg.com/uploads/tea/tea_PNG9892.png"
    ]
  }

  images = image_map[category.to_sym] || image_map[:pizza]
  images[index % images.length]
rescue
  "https://via.placeholder.com/400x300?text=#{category}+#{index}"
end

products = [
  # Pizza Category (6 products)
  {
    name: "Margherita Pizza",
    category: "pizza",
    price: 12.99,
    offer_price: 10.99,
    description: ["Classic tomato sauce", "Fresh mozzarella", "Basil leaves", "Olive oil"],
    in_stock: true,
    image_urls: [get_product_image("pizza", 0)]
  },
  {
    name: "Pepperoni Feast",
    category: "pizza",
    price: 15.99,
    offer_price: 13.99,
    description: ["Double pepperoni", "Mozzarella cheese", "Tomato sauce", "Italian herbs"],
    in_stock: true,
    image_urls: [get_product_image("pizza", 1)]
  },
  {
    name: "Vegetable Supreme",
    category: "pizza",
    price: 14.99,
    offer_price: 12.99,
    description: ["Bell peppers", "Onions", "Mushrooms", "Olives", "Tomatoes"],
    in_stock: true,
    image_urls: [get_product_image("pizza", 2)]
  },
  {
    name: "BBQ Chicken Pizza",
    category: "pizza",
    price: 16.99,
    offer_price: 14.99,
    description: ["Grilled chicken", "BBQ sauce", "Red onions", "Cilantro"],
    in_stock: true,
    image_urls: [get_product_image("pizza", 3)]
  },
  {
    name: "Four Cheese Pizza",
    category: "pizza",
    price: 17.99,
    offer_price: 15.99,
    description: ["Mozzarella", "Parmesan", "Gorgonzola", "Fontina"],
    in_stock: true,
    image_urls: [get_product_image("pizza", 4)]
  },
  {
    name: "Hawaiian Pizza",
    category: "pizza",
    price: 14.99,
    offer_price: 12.99,
    description: ["Ham", "Pineapple", "Mozzarella", "Tomato sauce"],
    in_stock: true,
    image_urls: [get_product_image("pizza", 5)]
  },

  # Burgers Category (6 products)
  {
    name: "Classic Cheeseburger",
    category: "burgers",
    price: 8.99,
    offer_price: 7.99,
    description: ["Beef patty", "Cheddar cheese", "Lettuce", "Tomato", "Pickles", "Special sauce"],
    in_stock: true,
    image_urls: [get_product_image("burgers", 0)]
  },
  {
    name: "Bacon Deluxe Burger",
    category: "burgers",
    price: 11.99,
    offer_price: 9.99,
    description: ["Double beef patty", "Crispy bacon", "American cheese", "Caramelized onions"],
    in_stock: true,
    image_urls: [get_product_image("burgers", 1)]
  },
  {
    name: "Mushroom Swiss Burger",
    category: "burgers",
    price: 10.99,
    offer_price: 8.99,
    description: ["Beef patty", "Sautéed mushrooms", "Swiss cheese", "Garlic aioli"],
    in_stock: true,
    image_urls: [get_product_image("burgers", 2)]
  },
  {
    name: "Spicy Jalapeño Burger",
    category: "burgers",
    price: 10.99,
    offer_price: 8.99,
    description: ["Beef patty", "Pepper jack cheese", "Jalapeños", "Sriracha mayo"],
    in_stock: true,
    image_urls: [get_product_image("burgers", 3)]
  },
  {
    name: "Veggie Burger",
    category: "burgers",
    price: 9.99,
    offer_price: 7.99,
    description: ["Black bean patty", "Avocado", "Sprouts", "Vegan mayo"],
    in_stock: true,
    image_urls: [get_product_image("burgers", 4)]
  },
  {
    name: "Chicken Crispy Burger",
    category: "burgers",
    price: 9.99,
    offer_price: 7.99,
    description: ["Crispy chicken", "Lettuce", "Tomato", "Honey mustard"],
    in_stock: true,
    image_urls: [get_product_image("burgers", 5)]
  },

  # Sushi Category (5 products)
  {
    name: "California Roll",
    category: "sushi",
    price: 12.99,
    offer_price: 10.99,
    description: ["Crab stick", "Avocado", "Cucumber", "Sesame seeds"],
    in_stock: true,
    image_urls: [get_product_image("sushi", 0)]
  },
  {
    name: "Salmon Nigiri Set",
    category: "sushi",
    price: 16.99,
    offer_price: 14.99,
    description: ["Fresh salmon", "Sushi rice", "Wasabi", "Soy sauce"],
    in_stock: true,
    image_urls: [get_product_image("sushi", 1)]
  },
  {
    name: "Dragon Roll",
    category: "sushi",
    price: 18.99,
    offer_price: 16.99,
    description: ["Eel", "Cucumber", "Avocado", "Unagi sauce"],
    in_stock: true,
    image_urls: [get_product_image("sushi", 2)]
  },
  {
    name: "Tuna Sashimi",
    category: "sushi",
    price: 19.99,
    offer_price: 17.99,
    description: ["Fresh tuna slices", "Daikon", "Shiso leaves"],
    in_stock: true,
    image_urls: [get_product_image("sushi", 3)]
  },
  {
    name: "Rainbow Roll",
    category: "sushi",
    price: 20.99,
    offer_price: 18.99,
    description: ["Assorted fish", "Avocado", "Cucumber", "Crab stick"],
    in_stock: true,
    image_urls: [get_product_image("sushi", 4)]
  },

  # Chinese Category (5 products)
  {
    name: "Kung Pao Chicken",
    category: "chinese",
    price: 13.99,
    offer_price: 11.99,
    description: ["Diced chicken", "Peanuts", "Vegetables", "Chili peppers"],
    in_stock: true,
    image_urls: [get_product_image("chinese", 0)]
  },
  {
    name: "Vegetable Spring Rolls",
    category: "chinese",
    price: 6.99,
    offer_price: 5.99,
    description: ["Crispy rolls", "Mixed vegetables", "Sweet chili sauce"],
    in_stock: true,
    image_urls: [get_product_image("chinese", 1)]
  },
  {
    name: "Fried Rice",
    category: "chinese",
    price: 10.99,
    offer_price: 8.99,
    description: ["Rice", "Eggs", "Peas", "Carrots", "Spring onions"],
    in_stock: true,
    image_urls: [get_product_image("chinese", 2)]
  },
  {
    name: "Sweet and Sour Pork",
    category: "chinese",
    price: 14.99,
    offer_price: 12.99,
    description: ["Battered pork", "Pineapple", "Bell peppers", "Sweet and sour sauce"],
    in_stock: true,
    image_urls: [get_product_image("chinese", 3)]
  },
  {
    name: "Dim Sum Platter",
    category: "chinese",
    price: 15.99,
    offer_price: 13.99,
    description: ["Pork dumplings", "Shrimp dumplings", "Siu mai", "Har gow"],
    in_stock: true,
    image_urls: [get_product_image("chinese", 4)]
  },

  # Desserts Category (5 products)
  {
    name: "Chocolate Lava Cake",
    category: "desserts",
    price: 7.99,
    offer_price: 6.99,
    description: ["Warm chocolate cake", "Molten center", "Vanilla ice cream"],
    in_stock: true,
    image_urls: [get_product_image("desserts", 0)]
  },
  {
    name: "New York Cheesecake",
    category: "desserts",
    price: 6.99,
    offer_price: 5.99,
    description: ["Cream cheese filling", "Graham cracker crust", "Berry compote"],
    in_stock: true,
    image_urls: [get_product_image("desserts", 1)]
  },
  {
    name: "Tiramisu",
    category: "desserts",
    price: 7.99,
    offer_price: 6.99,
    description: ["Coffee-soaked ladyfingers", "Mascarpone cream", "Cocoa powder"],
    in_stock: true,
    image_urls: [get_product_image("desserts", 2)]
  },
  {
    name: "Apple Pie",
    category: "desserts",
    price: 5.99,
    offer_price: 4.99,
    description: ["Fresh apples", "Cinnamon", "Buttery crust", "Vanilla sauce"],
    in_stock: true,
    image_urls: [get_product_image("desserts", 3)]
  },
  {
    name: "Mango Sticky Rice",
    category: "desserts",
    price: 8.99,
    offer_price: 7.99,
    description: ["Sweet mango", "Coconut sticky rice", "Sesame seeds"],
    in_stock: true,
    image_urls: [get_product_image("desserts", 4)]
  },

  # Beverages Category (5 products)
  {
    name: "Fresh Orange Juice",
    category: "beverages",
    price: 4.99,
    offer_price: 3.99,
    description: ["Freshly squeezed oranges", "No added sugar", "Served chilled"],
    in_stock: true,
    image_urls: [get_product_image("beverages", 0)]
  },
  {
    name: "Iced Caramel Latte",
    category: "beverages",
    price: 5.99,
    offer_price: 4.99,
    description: ["Espresso", "Milk", "Caramel syrup", "Ice"],
    in_stock: true,
    image_urls: [get_product_image("beverages", 1)]
  },
  {
    name: "Matcha Green Tea",
    category: "beverages",
    price: 4.99,
    offer_price: 3.99,
    description: ["Ceremonial grade matcha", "Honey", "Hot water"],
    in_stock: true,
    image_urls: [get_product_image("beverages", 2)]
  },
  {
    name: "Mango Smoothie",
    category: "beverages",
    price: 5.99,
    offer_price: 4.99,
    description: ["Fresh mango", "Yogurt", "Honey", "Ice"],
    in_stock: true,
    image_urls: [get_product_image("beverages", 3)]
  },
  {
    name: "Bubble Tea",
    category: "beverages",
    price: 5.99,
    offer_price: 4.99,
    description: ["Milk tea", "Tapioca pearls", "Brown sugar"],
    in_stock: true,
    image_urls: [get_product_image("beverages", 4)]
  }
]

products.each do |product_data|
  Product.create!(product_data)
rescue => e
  puts "Failed to create product #{product_data[:name]}: #{e.message}"
  # Try with placeholder image as fallback
  Product.create!(product_data.merge(image_urls: ["https://via.placeholder.com/400x300?text=#{product_data[:name].gsub(' ', '+')}"]))
end
puts "Created #{Product.count} products"





puts "Seeding completed successfully!"
puts "=================================="




# puts "Admin login: admin@fooddelivery.com / password123"
