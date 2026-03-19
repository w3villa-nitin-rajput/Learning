# Solid Queue Configuration and Logging
# This initializer ensures Solid Queue is properly configured for production

puts "[SolidQueue] =============================================================="
puts "[SolidQueue] Initializing Solid Queue Configuration"
puts "[SolidQueue] =============================================================="
puts "[SolidQueue] SOLID_QUEUE_IN_PUMA: #{ENV.fetch('SOLID_QUEUE_IN_PUMA', 'not set')}"
puts "[SolidQueue] RAILS_ENV: #{Rails.env}"
puts "[SolidQueue] Active Job Queue Adapter: #{Rails.application.config.active_job.queue_adapter}"

if File.exist?(Rails.root.join("config/recurring.yml"))
  puts "[SolidQueue] ✓ recurring.yml found"

  begin
    recurring_config = YAML.load_file(Rails.root.join("config/recurring.yml"))
    environment_config = recurring_config[Rails.env] || {}

    if environment_config.any?
      puts "[SolidQueue] Recurring jobs for #{Rails.env} environment:"
      environment_config.each do |job_name, job_config|
        job_spec = job_config["class"] || job_config["command"]
        schedule = job_config["schedule"]
        puts "[SolidQueue]   • #{job_name}: #{job_spec} @ #{schedule}"
      end
    else
      puts "[SolidQueue] ⚠ No recurring jobs configured for #{Rails.env}"
    end
  rescue => e
    puts "[SolidQueue] ✗ Error loading recurring.yml: #{e.message}"
  end
else
  puts "[SolidQueue] ✗ recurring.yml NOT found!"
end

puts "[SolidQueue] =============================================================="
puts "[SolidQueue] Solid Queue Ready"
puts "[SolidQueue] =============================================================="
