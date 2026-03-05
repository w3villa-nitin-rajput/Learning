class CloudinaryController < ApplicationController
  before_action :authorize_request

  def signature
    timestamp = Time.now.to_i
    # You can pass additional parameters to sign if needed, like folder, tags, etc.
    params_to_sign = {
      timestamp: timestamp,
      # upload_preset: 'your_preset_name' if you are using signed upload presets
    }

    # Generate the signature using the Cloudinary API secret
    signature = Cloudinary::Utils.api_sign_request(params_to_sign, ENV['CLOUDINARY_API_SECRET'])

    render json: {
      signature: signature,
      timestamp: timestamp,
      cloud_name: ENV['CLOUDINARY_CLOUD_NAME'],
      api_key: ENV['CLOUDINARY_API_KEY']
    }, status: :ok
  end
end
