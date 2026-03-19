# Solid Queue Configuration and Logging
# This initializer ensures Solid Queue is properly configured for production

if defined?(SolidQueue)
  Rails.logger.info "=" * 60
  Rails.logger.info "Solid Queue Initializer Starting"
  Rails.logger.info "=" * 60
  Rails.logger.info "SOLID_QUEUE_IN_PUMA: #{ENV.fetch('SOLID_QUEUE_IN_PUMA', 'not set')}"
  Rails.logger.info "RAILS_ENV: #{Rails.env}"
  Rails.logger.info "Active Job Queue Adapter: #{Rails.application.config.active_job.queue_adapter}"

  if File.exist?(Rails.root.join("config/recurring.yml"))
    Rails.logger.info "✓ recurring.yml found at config/recurring.yml"

    # Load and log the recurring jobs configured for this environment
    recurring_config = YAML.load_file(Rails.root.join("config/recurring.yml"))
    environment_config = recurring_config[Rails.env] || {}

    Rails.logger.info "Recurring jobs configured for #{Rails.env}:"
    environment_config.each do |job_name, job_config|
      Rails.logger.info "  - #{job_name}: #{job_config['class'] || job_config['command']} (#{job_config['schedule']})"
    end
  else
    Rails.logger.warn "✗ recurring.yml NOT found! Recurring jobs will not run."
  end

  Rails.logger.info "=" * 60
  Rails.logger.info "Solid Queue Initializer Complete"
  Rails.logger.info "=" * 60
end
