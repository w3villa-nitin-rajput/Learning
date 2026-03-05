# frozen_string_literal: true

# Seeds for Categories & Products
# Uploads images from the React frontend assets to Cloudinary

ASSETS_PATH = File.expand_path("../../ZEPTO/src/assets", Rails.root)

def upload_to_cloudinary(filename, folder)
  file_path = File.join(ASSETS_PATH, filename)
  unless File.exist?(file_path)
    puts "  ⚠ Image not found: #{filename}, skipping upload"
    return nil
  end

  result = Cloudinary::Uploader.upload(file_path, folder: folder, resource_type: "image")
  puts "  ✓ Uploaded #{filename} → #{result['secure_url']}"
  result["secure_url"]
rescue => e
  puts "  ✗ Failed to upload #{filename}: #{e.message}"
  nil
end

puts "=== Seeding Categories ==="

categories_data = [
  { name: "Organic veggies", path: "Vegetables", image_file: "organic_vegitable_image.png", bg_color: "#FEF6DA" },
  { name: "Fresh Fruits",    path: "Fruits",     image_file: "fresh_fruits_image.png",      bg_color: "#FEE0E0" },
  { name: "Cold Drinks",     path: "Drinks",     image_file: "bottles_image.png",            bg_color: "#F0F5DE" },
  { name: "Instant Food",    path: "Instant",    image_file: "maggi_image.png",              bg_color: "#E1F5EC" },
  { name: "Dairy Products",  path: "Dairy",      image_file: "dairy_product_image.png",      bg_color: "#FEE6CD" },
  { name: "Bakery & Breads", path: "Bakery",     image_file: "bakery_image.png",             bg_color: "#E0F6FE" },
  { name: "Grains & Cereals", path: "Grains",    image_file: "grain_image.png",              bg_color: "#F1E3F9" },
]

categories_data.each do |cat|
  existing = Category.find_by(path: cat[:path])
  if existing
    puts "  → Category '#{cat[:name]}' already exists, skipping"
    next
  end

  image_url = upload_to_cloudinary(cat[:image_file], "zepto/categories")
  Category.create!(
    name: cat[:name],
    path: cat[:path],
    image_url: image_url,
    bg_color: cat[:bg_color]
  )
  puts "  ✓ Created category: #{cat[:name]}"
end

puts "\n=== Seeding Products ==="

products_data = [
  # Vegetables
  { name: "Potato 500g",   category: "Vegetables", price: 25,  offer_price: 20,  images: ["potato_image_1.png", "potato_image_2.png", "potato_image_3.png", "potato_image_4.png"], description: ["Fresh and organic", "Rich in carbohydrates", "Ideal for curries and fries"] },
  { name: "Tomato 1 kg",   category: "Vegetables", price: 40,  offer_price: 35,  images: ["tomato_image.png"], description: ["Juicy and ripe", "Rich in Vitamin C", "Perfect for salads and sauces", "Farm fresh quality"] },
  { name: "Carrot 500g",   category: "Vegetables", price: 30,  offer_price: 28,  images: ["carrot_image.png"], description: ["Sweet and crunchy", "Good for eyesight", "Ideal for juices and salads"] },
  { name: "Spinach 500g",  category: "Vegetables", price: 18,  offer_price: 15,  images: ["spinach_image_1.png"], description: ["Rich in iron", "High in vitamins", "Perfect for soups and salads"] },
  { name: "Onion 500g",    category: "Vegetables", price: 22,  offer_price: 19,  images: ["onion_image_1.png"], description: ["Fresh and pungent", "Perfect for cooking", "A kitchen staple"] },

  # Fruits
  { name: "Apple 1 kg",    category: "Fruits", price: 120, offer_price: 110, images: ["apple_image.png"], description: ["Crisp and juicy", "Rich in fiber", "Boosts immunity", "Perfect for snacking and desserts", "Organic and farm fresh"] },
  { name: "Orange 1 kg",   category: "Fruits", price: 80,  offer_price: 75,  images: ["orange_image.png"], description: ["Juicy and sweet", "Rich in Vitamin C", "Perfect for juices and salads"] },
  { name: "Banana 1 kg",   category: "Fruits", price: 50,  offer_price: 45,  images: ["banana_image_1.png"], description: ["Sweet and ripe", "High in potassium", "Great for smoothies and snacking"] },
  { name: "Mango 1 kg",    category: "Fruits", price: 150, offer_price: 140, images: ["mango_image_1.png"], description: ["Sweet and flavorful", "Perfect for smoothies and desserts", "Rich in Vitamin A"] },
  { name: "Grapes 500g",   category: "Fruits", price: 70,  offer_price: 65,  images: ["grapes_image_1.png"], description: ["Fresh and juicy", "Rich in antioxidants", "Perfect for snacking and fruit salads"] },

  # Dairy
  { name: "Amul Milk 1L",  category: "Dairy", price: 60,  offer_price: 55,  images: ["amul_milk_image.png"], description: ["Pure and fresh", "Rich in calcium", "Ideal for tea, coffee, and desserts", "Trusted brand quality"] },
  { name: "Paneer 200g",   category: "Dairy", price: 90,  offer_price: 85,  images: ["paneer_image.png"], description: ["Soft and fresh", "Rich in protein", "Ideal for curries and snacks"] },
  { name: "Eggs 12 pcs",   category: "Dairy", price: 90,  offer_price: 85,  images: ["eggs_image.png"], description: ["Farm fresh", "Rich in protein", "Ideal for breakfast and baking"] },
  { name: "Paneer Block 200g", category: "Dairy", price: 90, offer_price: 85, images: ["paneer_image_2.png"], description: ["Soft and fresh", "Rich in protein", "Ideal for curries and snacks"] },
  { name: "Cheese 200g",   category: "Dairy", price: 140, offer_price: 130, images: ["cheese_image.png"], description: ["Creamy and delicious", "Perfect for pizzas and sandwiches", "Rich in calcium"] },

  # Drinks
  { name: "Coca-Cola 1.5L", category: "Drinks", price: 80, offer_price: 75, images: ["coca_cola_image.png"], description: ["Refreshing and fizzy", "Perfect for parties and gatherings", "Best served chilled"] },
  { name: "Pepsi 1.5L",    category: "Drinks", price: 78, offer_price: 73, images: ["pepsi_image.png"], description: ["Chilled and refreshing", "Perfect for celebrations", "Best served cold"] },
  { name: "Sprite 1.5L",   category: "Drinks", price: 79, offer_price: 74, images: ["sprite_image_1.png"], description: ["Refreshing citrus taste", "Perfect for hot days", "Best served chilled"] },
  { name: "Fanta 1.5L",    category: "Drinks", price: 77, offer_price: 72, images: ["fanta_image_1.png"], description: ["Sweet and fizzy", "Great for parties and gatherings", "Best served cold"] },
  { name: "7 Up 1.5L",     category: "Drinks", price: 76, offer_price: 71, images: ["seven_up_image_1.png"], description: ["Refreshing lemon-lime flavor", "Perfect for refreshing", "Best served chilled"] },

  # Grains
  { name: "Basmati Rice 5kg",   category: "Grains", price: 550, offer_price: 520, images: ["basmati_rice_image.png"], description: ["Long grain and aromatic", "Perfect for biryani and pulao", "Premium quality"] },
  { name: "Wheat Flour 5kg",    category: "Grains", price: 250, offer_price: 230, images: ["wheat_flour_image.png"], description: ["High-quality whole wheat", "Soft and fluffy rotis", "Rich in nutrients"] },
  { name: "Organic Quinoa 500g", category: "Grains", price: 450, offer_price: 420, images: ["quinoa_image.png"], description: ["High in protein and fiber", "Gluten-free", "Rich in vitamins and minerals"] },
  { name: "Brown Rice 1kg",     category: "Grains", price: 120, offer_price: 110, images: ["brown_rice_image.png"], description: ["Whole grain and nutritious", "Helps in weight management", "Good source of magnesium"] },
  { name: "Barley 1kg",         category: "Grains", price: 150, offer_price: 140, images: ["barley_image.png"], description: ["Rich in fiber", "Helps improve digestion", "Low in fat and cholesterol"] },

  # Bakery
  { name: "Brown Bread 400g",         category: "Bakery", price: 40,  offer_price: 35,  images: ["brown_bread_image.png"], description: ["Soft and healthy", "Made from whole wheat", "Ideal for breakfast and sandwiches"] },
  { name: "Butter Croissant 100g",     category: "Bakery", price: 50,  offer_price: 45,  images: ["butter_croissant_image.png"], description: ["Flaky and buttery", "Freshly baked", "Perfect for breakfast or snacks"] },
  { name: "Chocolate Cake 500g",       category: "Bakery", price: 350, offer_price: 325, images: ["chocolate_cake_image.png"], description: ["Rich and moist", "Made with premium cocoa", "Ideal for celebrations and parties"] },
  { name: "Whole Bread 400g",          category: "Bakery", price: 45,  offer_price: 40,  images: ["whole_wheat_bread_image.png"], description: ["Healthy and nutritious", "Made with whole wheat flour", "Ideal for sandwiches and toast"] },
  { name: "Vanilla Muffins 6 pcs",     category: "Bakery", price: 100, offer_price: 90,  images: ["vanilla_muffins_image.png"], description: ["Soft and fluffy", "Perfect for a quick snack", "Made with real vanilla"] },

  # Instant
  { name: "Maggi Noodles 280g",   category: "Instant", price: 55, offer_price: 50, images: ["maggi_image.png"], description: ["Instant and easy to cook", "Delicious taste", "Popular among kids and adults"] },
  { name: "Top Ramen 270g",       category: "Instant", price: 45, offer_price: 40, images: ["top_ramen_image.png"], description: ["Quick and easy to prepare", "Spicy and flavorful", "Loved by college students and families"] },
  { name: "Knorr Cup Soup 70g",   category: "Instant", price: 35, offer_price: 30, images: ["knorr_soup_image.png"], description: ["Convenient for on-the-go", "Healthy and nutritious", "Variety of flavors"] },
  { name: "Yippee Noodles 260g",   category: "Instant", price: 50, offer_price: 45, images: ["yippee_image.png"], description: ["Non-fried noodles for healthier choice", "Tasty and filling", "Convenient for busy schedules"] },
  { name: "Oats Noodles 72g",     category: "Instant", price: 40, offer_price: 35, images: ["maggi_oats_image.png"], description: ["Healthy alternative with oats", "Good for digestion", "Perfect for breakfast or snacks"] },
]

products_data.each do |prod|
  existing = Product.find_by(name: prod[:name], category: prod[:category])
  if existing
    puts "  → Product '#{prod[:name]}' already exists, skipping"
    next
  end

  image_urls = prod[:images].filter_map do |img|
    upload_to_cloudinary(img, "zepto/products/#{prod[:category].downcase}")
  end

  Product.create!(
    name: prod[:name],
    category: prod[:category],
    price: prod[:price],
    offer_price: prod[:offer_price],
    image_urls: image_urls,
    description: prod[:description],
    in_stock: true
  )
  puts "  ✓ Created product: #{prod[:name]}"
end

puts "\n=== Seeding Complete ==="
puts "Categories: #{Category.count}"
puts "Products: #{Product.count}"
