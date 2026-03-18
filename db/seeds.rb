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
puts "Cleaning database..."
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
    discount_percentage: 0
  },
  {
    name: "Silver",
    plan_type: "silver",
    price: 9.99,
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
    price: 19.99,
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

puts "Creating categories..."
categories = [
  {
    name: "Pizza",
    path: "pizza",
    bg_color: "#FEF3C7",
    image_url: "https://images.unsplash.com/photo-1513104890138-7c749660a47f?w=400&h=300&fit=crop"
  },
  {
    name: "Burgers",
    path: "burgers",
    bg_color: "#FEE2E2",
    image_url: "https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400&h=300&fit=crop"
  },
  {
    name: "Sushi",
    path: "sushi",
    bg_color: "#D1FAE5",
    image_url: "https://images.unsplash.com/photo-1553621042-f6e147245754?w=400&h=300&fit=crop"
  },
  {
    name: "Chinese",
    path: "chinese",
    bg_color: "#FFEDD5",
    image_url: "https://images.unsplash.com/photo-1585032226651-759b368d7246?w=400&h=300&fit=crop"
  },
  {
    name: "Desserts",
    path: "desserts",
    bg_color: "#FCE7F3",
    image_url: "https://images.unsplash.com/photo-1551024506-0bccd828d307?w=400&h=300&fit=crop"
  },
  {
    name: "Beverages",
    path: "beverages",
    bg_color: "#DBEAFE",
    image_url: "https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400&h=300&fit=crop"
  }
]

created_categories = categories.map do |category_data|
  Category.create!(category_data)
end
puts "Created #{Category.count} categories"

puts "Creating food products..."
products = [
  # Pizza Category (6 products)
  {
    name: "Margherita Pizza",
    category: "pizza",
    price: 12.99,
    offer_price: 10.99,
    description: ["Classic tomato sauce", "Fresh mozzarella", "Basil leaves", "Olive oil"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1604068549290-dea0e4a305ca?w=400&h=300&fit=crop"]
  },
  {
    name: "Pepperoni Feast",
    category: "pizza",
    price: 15.99,
    offer_price: 13.99,
    description: ["Double pepperoni", "Mozzarella cheese", "Tomato sauce", "Italian herbs"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400&h=300&fit=crop"]
  },
  {
    name: "Vegetable Supreme",
    category: "pizza",
    price: 14.99,
    offer_price: 12.99,
    description: ["Bell peppers", "Onions", "Mushrooms", "Olives", "Tomatoes"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1574112310179-5b4ffbc33f9e?w=400&h=300&fit=crop"]
  },
  {
    name: "BBQ Chicken Pizza",
    category: "pizza",
    price: 16.99,
    offer_price: 14.99,
    description: ["Grilled chicken", "BBQ sauce", "Red onions", "Cilantro"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=300&fit=crop"]
  },
  {
    name: "Four Cheese Pizza",
    category: "pizza",
    price: 17.99,
    offer_price: 15.99,
    description: ["Mozzarella", "Parmesan", "Gorgonzola", "Fontina"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1542281286-9e0a16bb7366?w=400&h=300&fit=crop"]
  },
  {
    name: "Hawaiian Pizza",
    category: "pizza",
    price: 14.99,
    offer_price: 12.99,
    description: ["Ham", "Pineapple", "Mozzarella", "Tomato sauce"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1566843972143-a4a5ee57b2cb?w=400&h=300&fit=crop"]
  },

  # Burgers Category (6 products)
  {
    name: "Classic Cheeseburger",
    category: "burgers",
    price: 8.99,
    offer_price: 7.99,
    description: ["Beef patty", "Cheddar cheese", "Lettuce", "Tomato", "Pickles", "Special sauce"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=300&fit=crop"]
  },
  {
    name: "Bacon Deluxe Burger",
    category: "burgers",
    price: 11.99,
    offer_price: 9.99,
    description: ["Double beef patty", "Crispy bacon", "American cheese", "Caramelized onions"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=400&h=300&fit=crop"]
  },
  {
    name: "Mushroom Swiss Burger",
    category: "burgers",
    price: 10.99,
    offer_price: 8.99,
    description: ["Beef patty", "Sautéed mushrooms", "Swiss cheese", "Garlic aioli"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?w=400&h=300&fit=crop"]
  },
  {
    name: "Spicy Jalapeño Burger",
    category: "burgers",
    price: 10.99,
    offer_price: 8.99,
    description: ["Beef patty", "Pepper jack cheese", "Jalapeños", "Sriracha mayo"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1615297928064-249773f5e0d9?w=400&h=300&fit=crop"]
  },
  {
    name: "Veggie Burger",
    category: "burgers",
    price: 9.99,
    offer_price: 7.99,
    description: ["Black bean patty", "Avocado", "Sprouts", "Vegan mayo"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1585238342024-78d387f4a707?w=400&h=300&fit=crop"]
  },
  {
    name: "Chicken Crispy Burger",
    category: "burgers",
    price: 9.99,
    offer_price: 7.99,
    description: ["Crispy chicken", "Lettuce", "Tomato", "Honey mustard"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1606755962773-d324e3b2894b?w=400&h=300&fit=crop"]
  },

  # Sushi Category (5 products)
  {
    name: "California Roll",
    category: "sushi",
    price: 12.99,
    offer_price: 10.99,
    description: ["Crab stick", "Avocado", "Cucumber", "Sesame seeds"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=400&h=300&fit=crop"]
  },
  {
    name: "Salmon Nigiri Set",
    category: "sushi",
    price: 16.99,
    offer_price: 14.99,
    description: ["Fresh salmon", "Sushi rice", "Wasabi", "Soy sauce"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1617196035154-1e7e6e28b0db?w=400&h=300&fit=crop"]
  },
  {
    name: "Dragon Roll",
    category: "sushi",
    price: 18.99,
    offer_price: 16.99,
    description: ["Eel", "Cucumber", "Avocado", "Unagi sauce"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1611143669185-af224c5e3252?w=400&h=300&fit=crop"]
  },
  {
    name: "Tuna Sashimi",
    category: "sushi",
    price: 19.99,
    offer_price: 17.99,
    description: ["Fresh tuna slices", "Daikon", "Shiso leaves"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400&h=300&fit=crop"]
  },
  {
    name: "Rainbow Roll",
    category: "sushi",
    price: 20.99,
    offer_price: 18.99,
    description: ["Assorted fish", "Avocado", "Cucumber", "Crab stick"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1617196034798-4df24368b286?w=400&h=300&fit=crop"]
  },

  # Chinese Category (5 products)
  {
    name: "Kung Pao Chicken",
    category: "chinese",
    price: 13.99,
    offer_price: 11.99,
    description: ["Diced chicken", "Peanuts", "Vegetables", "Chili peppers"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1525755662778-989d0524087e?w=400&h=300&fit=crop"]
  },
  {
    name: "Vegetable Spring Rolls",
    category: "chinese",
    price: 6.99,
    offer_price: 5.99,
    description: ["Crispy rolls", "Mixed vegetables", "Sweet chili sauce"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1541698434-1e1dd5c46d3c?w=400&h=300&fit=crop"]
  },
  {
    name: "Fried Rice",
    category: "chinese",
    price: 10.99,
    offer_price: 8.99,
    description: ["Rice", "Eggs", "Peas", "Carrots", "Spring onions"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400&h=300&fit=crop"]
  },
  {
    name: "Sweet and Sour Pork",
    category: "chinese",
    price: 14.99,
    offer_price: 12.99,
    description: ["Battered pork", "Pineapple", "Bell peppers", "Sweet and sour sauce"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1548940740-2047ee6fcc47?w=400&h=300&fit=crop"]
  },
  {
    name: "Dim Sum Platter",
    category: "chinese",
    price: 15.99,
    offer_price: 13.99,
    description: ["Pork dumplings", "Shrimp dumplings", "Siu mai", "Har gow"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1582456891925-a2e9db1f9b81?w=400&h=300&fit=crop"]
  },

  # Desserts Category (5 products)
  {
    name: "Chocolate Lava Cake",
    category: "desserts",
    price: 7.99,
    offer_price: 6.99,
    description: ["Warm chocolate cake", "Molten center", "Vanilla ice cream"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400&h=300&fit=crop"]
  },
  {
    name: "New York Cheesecake",
    category: "desserts",
    price: 6.99,
    offer_price: 5.99,
    description: ["Cream cheese filling", "Graham cracker crust", "Berry compote"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1533134242443-d4fd215305ad?w=400&h=300&fit=crop"]
  },
  {
    name: "Tiramisu",
    category: "desserts",
    price: 7.99,
    offer_price: 6.99,
    description: ["Coffee-soaked ladyfingers", "Mascarpone cream", "Cocoa powder"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400&h=300&fit=crop"]
  },
  {
    name: "Apple Pie",
    category: "desserts",
    price: 5.99,
    offer_price: 4.99,
    description: ["Fresh apples", "Cinnamon", "Buttery crust", "Vanilla sauce"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1568571780763-9276ac8b75a8?w=400&h=300&fit=crop"]
  },
  {
    name: "Mango Sticky Rice",
    category: "desserts",
    price: 8.99,
    offer_price: 7.99,
    description: ["Sweet mango", "Coconut sticky rice", "Sesame seeds"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1621302971902-83c5b34aa6c3?w=400&h=300&fit=crop"]
  },

  # Beverages Category (5 products)
  {
    name: "Fresh Orange Juice",
    category: "beverages",
    price: 4.99,
    offer_price: 3.99,
    description: ["Freshly squeezed oranges", "No added sugar", "Served chilled"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1613478225612-7f3b8d6e2b8c?w=400&h=300&fit=crop"]
  },
  {
    name: "Iced Caramel Latte",
    category: "beverages",
    price: 5.99,
    offer_price: 4.99,
    description: ["Espresso", "Milk", "Caramel syrup", "Ice"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400&h=300&fit=crop"]
  },
  {
    name: "Matcha Green Tea",
    category: "beverages",
    price: 4.99,
    offer_price: 3.99,
    description: ["Ceremonial grade matcha", "Honey", "Hot water"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1536256263959-770afea1dd52?w=400&h=300&fit=crop"]
  },
  {
    name: "Mango Smoothie",
    category: "beverages",
    price: 5.99,
    offer_price: 4.99,
    description: ["Fresh mango", "Yogurt", "Honey", "Ice"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1627308595171-d1b5d671015b?w=400&h=300&fit=crop"]
  },
  {
    name: "Bubble Tea",
    category: "beverages",
    price: 5.99,
    offer_price: 4.99,
    description: ["Milk tea", "Tapioca pearls", "Brown sugar"],
    in_stock: true,
    image_urls: ["https://images.unsplash.com/photo-1558857563-c0e3f5f0e9c8?w=400&h=300&fit=crop"]
  }
]

products.each do |product_data|
  Product.create!(product_data)
end
puts "Created #{Product.count} products"


puts "Admin login: admin@fooddelivery.com / password123"
