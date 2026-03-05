# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_05_063618) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "cart_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["product_id"], name: "index_cart_items_on_product_id"
    t.index ["user_id"], name: "index_cart_items_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "bg_color"
    t.datetime "created_at", null: false
    t.string "image_url"
    t.string "name"
    t.string "path"
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "items", default: [], null: false
    t.string "payment_method", default: "COD", null: false
    t.string "payment_status", default: "Pending", null: false
    t.text "shipping_address", null: false
    t.integer "status", default: 0, null: false
    t.decimal "total", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.string "description", default: [], array: true
    t.string "image_urls", default: [], array: true
    t.boolean "in_stock", default: true
    t.string "name", null: false
    t.decimal "offer_price", precision: 10, scale: 2
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_products_on_category"
  end

  create_table "users", force: :cascade do |t|
    t.string "address"
    t.string "cloudinary_public_id"
    t.string "cloudinary_url"
    t.datetime "created_at", null: false
    t.string "email"
    t.boolean "email_verified"
    t.string "facebook_uid"
    t.string "google_oauth2_uid"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "name"
    t.string "password_digest"
    t.integer "role"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "cart_items", "products"
  add_foreign_key "cart_items", "users"
  add_foreign_key "orders", "users"
end
