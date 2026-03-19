class CategorySerializer
  include JSONAPI::Serializer
  attributes :name, :image_url, :bg_color, :path, :cloudinary_url, :cloudinary_public_id, :created_at, :updated_at
end
