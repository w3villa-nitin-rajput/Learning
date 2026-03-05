class ProductSerializer
  include JSONAPI::Serializer
  attributes :name, :price, :offer_price, :category, :image_urls, :description, :in_stock, :created_at, :updated_at
end
