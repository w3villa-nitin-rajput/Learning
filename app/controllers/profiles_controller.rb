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
  def download
    user = @current_user
    
    pdf = Prawn::Document.new
    pdf.font "Helvetica"
    pdf.text "User Profile", size: 28, style: :bold, align: :center, color: "0052cc"
    pdf.move_down 30
    
    pdf.text "Personal Information", size: 18, style: :bold, color: "333333"
    pdf.move_down 10
    
    data = [
      ["Name:", user.name.present? ? user.name : "N/A"],
      ["Email:", user.email],
      ["Address:", user.address.present? ? user.address : "N/A"],
      ["Plan:", user.active_plan_name.to_s.capitalize]
    ]
    
    if user.plan_expires_at.present? && user.plan_expires_at.future?
      data << ["Plan Expiry:", user.plan_expires_at.strftime('%B %d, %Y %I:%M %p')]
    end
    
    data.each do |row|
      pdf.formatted_text [
        { text: "#{row[0]} ", styles: [:bold], size: 14, color: "555555" },
        { text: row[1].to_s, size: 14, color: "000000" }
      ]
      pdf.move_down 8
    end
    
    pdf.move_down 20
    pdf.stroke_horizontal_rule
    pdf.move_down 10
    pdf.text "Generated on #{Time.current.strftime('%B %d, %Y')}", size: 10, align: :center, color: "888888"
    
    filename = "profile_#{user.name.present? ? user.name.parameterize : user.id}.pdf"
    send_data pdf.render, filename: filename, type: "application/pdf", disposition: "attachment"
  end

  private

  def profile_params
    params.permit(:cloudinary_url, :cloudinary_public_id, :address, :latitude, :longitude)
  end
end
