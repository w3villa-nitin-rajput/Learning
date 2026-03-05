class CartItemSerializer
  include JSONAPI::Serializer
  attributes :user_id, :product_id, :quantity, :created_at, :updated_at
end
