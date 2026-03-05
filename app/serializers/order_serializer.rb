class OrderSerializer
  include JSONAPI::Serializer
  attributes :user_id, :items, :total, :status, :payment_method, :payment_status, :shipping_address, :created_at, :updated_at
  belongs_to :user
end
