class ProductSerializer
  include JSONAPI::Serializer
  attributes :name, :price, :offer_price, :category, :image_urls, :description, :in_stock, :cloudinary_url, :cloudinary_public_id, :created_at, :updated_at
end
