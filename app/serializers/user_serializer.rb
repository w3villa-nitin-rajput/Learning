class UserSerializer
  include JSONAPI::Serializer
  attributes :name, :email, :role, :cloudinary_url, :cloudinary_public_id, :address, :latitude, :longitude, :email_verified, :created_at, :updated_at
end
