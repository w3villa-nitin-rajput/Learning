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
Order.destroy_all
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

puts "Creating  user..."
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
    price: 9.99,
    duration_hours: 720, # 30 days
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
    duration_hours: 720, # 30 days
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
    image_url: "https://purepng.com/public/uploads/large/purepng.com-pizzapizza-italian-cuisinedough-tomato-cheese-1411528357169oywpe.png"
  },
  {
    name: "Burgers",
    path: "burgers",
    bg_color: "#FEE2E2",
    image_url: "https://purepng.com/public/uploads/large/purepng.com-burger-burger-hamburger-cheeseburger-fast-food-bread-631522931981atwoc.png"
  },
  {
    name: "Sushi",
    path: "sushi",
    bg_color: "#D1FAE5",
    image_url: "https://purepng.com/public/uploads/large/purepng.com-sushisushijapanese-foodvinegared-rice seafood-631522932043m5hbc.png"
  },
  {
    name: "Chinese",
    path: "chinese",
    bg_color: "#FFEDD5",
    image_url: "https://purepng.com/public/uploads/large/purepng.com-chinese-foodchinesefood-9815252321793ct6d.png"
  },
  {
    name: "Desserts",
    path: "desserts",
    bg_color: "#FCE7F3",
    image_url: "https://purepng.com/public/uploads/large/purepng.com-cupcakecupcake-small-cakemuffincupcakefrostingsprinkles-631522931772akqij.png"
  },
  {
    name: "Beverages",
    path: "beverages",
    bg_color: "#DBEAFE",
    image_url: "https://purepng.com/public/uploads/large/purepng.com-soda-can-assodacoke-soft-drink-coca-cola-631522932157ambop.png"
  }
]

created_categories = categories.map do |category_data|
  Category.create!(category_data)
end
puts "Created #{Category.count} categories"

puts "Creating food products with transparent PNGs..."
products = [
  # Pizza Category (6 products)
  {
    name: "Margherita Pizza",
    category: "pizza",
    price: 12.99,
    offer_price: 10.99,
    description: ["Classic tomato sauce", "Fresh mozzarella", "Basil leaves", "Olive oil"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-pizzapizza-italian-cuisinedough-tomato-cheese-1411528357169oywpe.png"]
  },
  {
    name: "Pepperoni Feast",
    category: "pizza",
    price: 15.99,
    offer_price: 13.99,
    description: ["Double pepperoni", "Mozzarella cheese", "Tomato sauce", "Italian herbs"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-pepperoni-pizzapizza-pepperonifood-9415248240369c0g4.png"]
  },
  {
    name: "Vegetable Supreme",
    category: "pizza",
    price: 14.99,
    offer_price: 12.99,
    description: ["Bell peppers", "Onions", "Mushrooms", "Olives", "Tomatoes"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-vegetable-pizzapizza-italian-cuisinevegetarian-1411528357344u4gqe.png"]
  },
  {
    name: "BBQ Chicken Pizza",
    category: "pizza",
    price: 16.99,
    offer_price: 14.99,
    description: ["Grilled chicken", "BBQ sauce", "Red onions", "Cilantro"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-bbq-chicken-pizzapizza-italian-cuisinebbq-chicken-1411528355582jpqph.png"]
  },
  {
    name: "Four Cheese Pizza",
    category: "pizza",
    price: 17.99,
    offer_price: 15.99,
    description: ["Mozzarella", "Parmesan", "Gorgonzola", "Fontina"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-cheese-pizzapizza-italian-cuisinecheese-food-1411528355380yq3mr.png"]
  },
  {
    name: "Hawaiian Pizza",
    category: "pizza",
    price: 14.99,
    offer_price: 12.99,
    description: ["Ham", "Pineapple", "Mozzarella", "Tomato sauce"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-hawaiian-pizzapizza-italian-cuisinehawaiian-food-1411528355940lpn7w.png"]
  },

  # Burgers Category (6 products)
  {
    name: "Classic Cheeseburger",
    category: "burgers",
    price: 8.99,
    offer_price: 7.99,
    description: ["Beef patty", "Cheddar cheese", "Lettuce", "Tomato", "Pickles", "Special sauce"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-burgerburger-hamburger-cheeseburger-fast-food-bread-631522931981atwoc.png"]
  },
  {
    name: "Bacon Deluxe Burger",
    category: "burgers",
    price: 11.99,
    offer_price: 9.99,
    description: ["Double beef patty", "Crispy bacon", "American cheese", "Caramelized onions"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-bacon-burgerburger-hamburger-cheeseburger-fast-food-bread-631522931962aeewh.png"]
  },
  {
    name: "Mushroom Swiss Burger",
    category: "burgers",
    price: 10.99,
    offer_price: 8.99,
    description: ["Beef patty", "Sautéed mushrooms", "Swiss cheese", "Garlic aioli"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-mushroom-burgerburger-hamburger-cheeseburger-fast-food-bread-631522931969mptd1.png"]
  },
  {
    name: "Spicy Jalapeño Burger",
    category: "burgers",
    price: 10.99,
    offer_price: 8.99,
    description: ["Beef patty", "Pepper jack cheese", "Jalapeños", "Sriracha mayo"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-spicy-burgerburger-hamburger-cheeseburger-fast-food-bread-631522931998ljf4m.png"]
  },
  {
    name: "Veggie Burger",
    category: "burgers",
    price: 9.99,
    offer_price: 7.99,
    description: ["Black bean patty", "Avocado", "Sprouts", "Vegan mayo"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-veggie-burgerburger-hamburger-cheeseburger-fast-food-bread-631522932003ryqtl.png"]
  },
  {
    name: "Chicken Crispy Burger",
    category: "burgers",
    price: 9.99,
    offer_price: 7.99,
    description: ["Crispy chicken", "Lettuce", "Tomato", "Honey mustard"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-chicken-burgerburger-hamburger-cheeseburger-fast-food-bread-631522931955krd7k.png"]
  },

  # Sushi Category (5 products)
  {
    name: "California Roll",
    category: "sushi",
    price: 12.99,
    offer_price: 10.99,
    description: ["Crab stick", "Avocado", "Cucumber", "Sesame seeds"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-california-roll-sushisushijapanese-foodvinegared-rice-631522932064rm0og.png"]
  },
  {
    name: "Salmon Nigiri Set",
    category: "sushi",
    price: 16.99,
    offer_price: 14.99,
    description: ["Fresh salmon", "Sushi rice", "Wasabi", "Soy sauce"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-salmon-sushisushijapanese-foodvinegared-rice-seafood-631522932100bjtja.png"]
  },
  {
    name: "Dragon Roll",
    category: "sushi",
    price: 18.99,
    offer_price: 16.99,
    description: ["Eel", "Cucumber", "Avocado", "Unagi sauce"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-dragon-roll-sushisushijapanese-foodvinegared-rice-6315229320814ugmb.png"]
  },
  {
    name: "Tuna Sashimi",
    category: "sushi",
    price: 19.99,
    offer_price: 17.99,
    description: ["Fresh tuna slices", "Daikon", "Shiso leaves"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-tuna-sashimi-sushisushijapanese-foodvinegared-rice-631522932120tbq3w.png"]
  },
  {
    name: "Rainbow Roll",
    category: "sushi",
    price: 20.99,
    offer_price: 18.99,
    description: ["Assorted fish", "Avocado", "Cucumber", "Crab stick"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-rainbow-roll-sushisushijapanese-foodvinegared-rice-631522932113s9t12.png"]
  },

  # Chinese Category (5 products)
  {
    name: "Kung Pao Chicken",
    category: "chinese",
    price: 13.99,
    offer_price: 11.99,
    description: ["Diced chicken", "Peanuts", "Vegetables", "Chili peppers"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-kung-pao-chickenchinesefoodkung-paochicken-63152293176dflis.png"]
  },
  {
    name: "Vegetable Spring Rolls",
    category: "chinese",
    price: 6.99,
    offer_price: 5.99,
    description: ["Crispy rolls", "Mixed vegetables", "Sweet chili sauce"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-spring-rollschinesefoodspring-rolls-63152293194cxbcb.png"]
  },
  {
    name: "Fried Rice",
    category: "chinese",
    price: 10.99,
    offer_price: 8.99,
    description: ["Rice", "Eggs", "Peas", "Carrots", "Spring onions"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-fried-ricechinesefoodfried-rice-63152293187lwqqt.png"]
  },
  {
    name: "Sweet and Sour Pork",
    category: "chinese",
    price: 14.99,
    offer_price: 12.99,
    description: ["Battered pork", "Pineapple", "Bell peppers", "Sweet and sour sauce"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-sweet-and-sour-porkchinesefoodsweet-sour-pork-63152293199of3xf.png"]
  },
  {
    name: "Dim Sum Platter",
    category: "chinese",
    price: 15.99,
    offer_price: 13.99,
    description: ["Pork dumplings", "Shrimp dumplings", "Siu mai", "Har gow"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-dim-sumchinesefooddim-sum-631522931854l0c8.png"]
  },

  # Desserts Category (5 products)
  {
    name: "Chocolate Lava Cake",
    category: "desserts",
    price: 7.99,
    offer_price: 6.99,
    description: ["Warm chocolate cake", "Molten center", "Vanilla ice cream"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-chocolate-cakecakechocolatecakesweet-dessert-631522931799cltvm.png"]
  },
  {
    name: "New York Cheesecake",
    category: "desserts",
    price: 6.99,
    offer_price: 5.99,
    description: ["Cream cheese filling", "Graham cracker crust", "Berry compote"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-cheesecakecakechocolatecakesweet-dessert-631522931777mzq6r.png"]
  },
  {
    name: "Tiramisu",
    category: "desserts",
    price: 7.99,
    offer_price: 6.99,
    description: ["Coffee-soaked ladyfingers", "Mascarpone cream", "Cocoa powder"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-tiramisucaketiramisudessertfood-6315229321388qjqp.png"]
  },
  {
    name: "Apple Pie",
    category: "desserts",
    price: 5.99,
    offer_price: 4.99,
    description: ["Fresh apples", "Cinnamon", "Buttery crust", "Vanilla sauce"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-apple-pieapple-piedessertpie-631522931731dq4t.png"]
  },
  {
    name: "Mango Sticky Rice",
    category: "desserts",
    price: 8.99,
    offer_price: 7.99,
    description: ["Sweet mango", "Coconut sticky rice", "Sesame seeds"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-mango-sticky-rice-mango-sticky-ricedessertfood-631522932079sue3r.png"]
  },

  # Beverages Category (5 products)
  {
    name: "Fresh Orange Juice",
    category: "beverages",
    price: 4.99,
    offer_price: 3.99,
    description: ["Freshly squeezed oranges", "No added sugar", "Served chilled"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-orange-juiceorange-juicejuiceorangefruit-63152293199cmjye.png"]
  },
  {
    name: "Iced Caramel Latte",
    category: "beverages",
    price: 5.99,
    offer_price: 4.99,
    description: ["Espresso", "Milk", "Caramel syrup", "Ice"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-ice-coffeecoffeedrinkbeveragebreakfast-631522931958exd2s.png"]
  },
  {
    name: "Matcha Green Tea",
    category: "beverages",
    price: 4.99,
    offer_price: 3.99,
    description: ["Ceremonial grade matcha", "Honey", "Hot water"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-matcha-teamatcha-powder-teagrean-teamatcha-631522932048m6kps.png"]
  },
  {
    name: "Mango Smoothie",
    category: "beverages",
    price: 5.99,
    offer_price: 4.99,
    description: ["Fresh mango", "Yogurt", "Honey", "Ice"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-smoothiesmoothiedrinkbeverage-631522932106ogcfb.png"]
  },
  {
    name: "Bubble Tea",
    category: "beverages",
    price: 5.99,
    offer_price: 4.99,
    description: ["Milk tea", "Tapioca pearls", "Brown sugar"],
    in_stock: true,
    image_urls: ["https://purepng.com/public/uploads/large/purepng.com-bubble-teabubble-teamilk-teamilk-6315229319469w4ky.png"]
  }
]

products.each do |product_data|
  Product.create!(product_data)
end
puts "Created #{Product.count} products"




puts "Seeding completed successfully!"
puts "=================================="




# puts "Admin login: admin@fooddelivery.com / password123"
