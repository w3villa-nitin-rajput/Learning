class UserSerializer
  include JSONAPI::Serializer
  attributes :name, :email, :role, :cloudinary_url, :cloudinary_public_id, :address, :latitude, :longitude, :email_verified, :created_at, :updated_at, :plan_expires_at, :plan

  attribute :plan do |user|
    user.active_plan_name
  end
end
