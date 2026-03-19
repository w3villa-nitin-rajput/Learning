Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Use an array to handle multiple origins cleanly
    allowed_origins = [ "http://localhost:5173", "http://localhost:3000", "https://mini-project-frontend-mfo2.onrender.com" ]

    # Add the production URL if the environment variable exists
    if ENV["FRONTEND_URL"].present?
      frontend_url = ENV["FRONTEND_URL"].delete_suffix("/")
      allowed_origins << frontend_url unless allowed_origins.include?(frontend_url)
      puts "[CORS] Frontend URL configured: #{frontend_url}"
    else
      puts "[CORS] Warning: FRONTEND_URL not set, using defaults including Production URL"
    end

    origins allowed_origins
    puts "[CORS] Allowed origins: #{allowed_origins.join(', ')}"

    resource "*",
      headers: :any,
      expose: [ "Content-Disposition", "Content-Type", "Authorization", "X-Requested-With" ],
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
      credentials: true
  end

  # Allow access to debug endpoints from any origin in development if needed
  allow do
    origins "*"
    resource "/debug/*", headers: :any, methods: [ :get, :options ]
  end
end
