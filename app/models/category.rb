class Category < ApplicationRecord
  validates :name, presence: true
  validates :path, presence: true, uniqueness: true
  validates :bg_color, presence: true

  # Delete old image from Cloudinary if a new one is being uploaded
  def delete_old_cloudinary_image
    return unless cloudinary_public_id.present?

    begin
      Cloudinary::Uploader.destroy(cloudinary_public_id)
      Rails.logger.info "Deleted Cloudinary image: #{cloudinary_public_id}"
    rescue StandardError => e
      Rails.logger.error "Failed to delete Cloudinary image (#{cloudinary_public_id}): #{e.message}"
    end
  end
end
