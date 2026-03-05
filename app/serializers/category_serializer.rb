class CategorySerializer
  include JSONAPI::Serializer
  attributes :name, :image_url, :bg_color, :path, :created_at, :updated_at
end
