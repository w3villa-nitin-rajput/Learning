class ProfilesController < ApplicationController
  before_action :authorize_request

  def update
    user = @current_user
    old_public_id = user.cloudinary_public_id

    if user.update(profile_params)
      # If a new image was uploaded and there was an old one, delete the old one from Cloudinary
      if profile_params[:cloudinary_public_id].present? && old_public_id.present? && old_public_id != profile_params[:cloudinary_public_id]
        begin
          Cloudinary::Uploader.destroy(old_public_id)
        rescue StandardError => e
          Rails.logger.error("Failed to delete old Cloudinary image: #{e.message}")
        end
      end

      render json: UserSerializer.new(user).serializable_hash[:data][:attributes].merge(id: user.id), status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.permit(:cloudinary_url, :cloudinary_public_id, :address, :latitude, :longitude)
  end
end
