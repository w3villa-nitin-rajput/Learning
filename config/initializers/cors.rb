Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Use an array to handle multiple origins cleanly
    allowed_origins = ['http://localhost:5173']
    
    # Add the production URL if the environment variable exists
    if ENV["FRONTEND_URL"].present?
      # We strip trailing slashes to ensure the match is exact
      allowed_origins << ENV["FRONTEND_URL"].delete_suffix('/')
    end

    origins allowed_origins

    resource '*',
      headers: :any,
      expose: ['Content-Disposition'],
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true # Add this if you use sessions/cookies/Devise
  end
end