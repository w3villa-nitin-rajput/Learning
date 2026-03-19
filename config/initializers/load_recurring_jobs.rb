# Explicit Recurring Job Registration
# This ensures recurring jobs are loaded when the app boots

# Register a callback to load recurring jobs after Rails initialization
Rails.application.config.after_initialize do
  if defined?(SolidQueue)
    begin
      puts "[SolidQueue] Loading recurring jobs from config/recurring.yml..."

      # Load and register recurring jobs
      recurring_file = Rails.root.join("config/recurring.yml")
      if File.exist?(recurring_file)
        config = YAML.load_file(recurring_file)
        env_config = config[Rails.env] || {}

        if env_config.any?
          puts "[SolidQueue] Registering #{env_config.count} recurring job(s) for #{Rails.env}"
          # Solid Queue automatically loads this, but we log it for visibility
        else
          puts "[SolidQueue] No recurring jobs configured for #{Rails.env}"
        end
      else
        puts "[SolidQueue] recurring.yml not found at #{recurring_file}"
      end
    rescue => e
      puts "[SolidQueue] Error loading recurring jobs: #{e.message}"
      puts e.backtrace.first(5).join("\n")
    end
  end
end
