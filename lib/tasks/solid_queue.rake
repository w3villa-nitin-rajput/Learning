namespace :solid_queue do
  desc "Check Solid Queue configuration and recurring jobs"
  task status: :environment do
    puts "\n" + "=" * 70
    puts "SOLID QUEUE STATUS CHECK"
    puts "=" * 70

    # Check environment
    puts "\n📋 Environment:"
    puts "  RAILS_ENV: #{Rails.env}"
    puts "  SOLID_QUEUE_IN_PUMA: #{ENV.fetch('SOLID_QUEUE_IN_PUMA', 'not set')}"
    puts "  Active Job Adapter: #{Rails.application.config.active_job.queue_adapter}"

    # Check queue database
    puts "\n📊 Queue Database:"
    begin
      queue_db = SolidQueue::Job.connection
      job_count = SolidQueue::Job.count
      puts "  ✓ Connected to queue database"
      puts "  Jobs in queue: #{job_count}"
    rescue => e
      puts "  ✗ Error connecting to queue database: #{e.message}"
    end

    # Check recurring jobs configuration
    puts "\n⏰ Recurring Jobs Configuration (config/recurring.yml):"
    recurring_file = Rails.root.join("config/recurring.yml")
    if File.exist?(recurring_file)
      begin
        config = YAML.load_file(recurring_file)
        env_jobs = config[Rails.env] || {}

        if env_jobs.empty?
          puts "  ⚠ No recurring jobs configured for #{Rails.env}"
        else
          puts "  ✓ Found #{env_jobs.count} recurring job(s) for #{Rails.env}:"
          env_jobs.each do |name, job_config|
            job_type = job_config["class"] ? "Class" : "Command"
            schedule = job_config["schedule"]
            puts "    - #{name} (#{job_type}): #{schedule}"
            puts "      Details: #{job_config['class'] || job_config['command']}"
          end
        end
      rescue => e
        puts "  ✗ Error loading recurring.yml: #{e.message}"
      end
    else
      puts "  ✗ config/recurring.yml not found!"
    end

    # Check if ExpirePlansJob exists
    puts "\n🔧 ExpirePlansJob:"
    begin
      job_class = "ExpirePlansJob".constantize
      puts "  ✓ Job class found and loaded"
      puts "  Queue: #{job_class.new.queue_name}"
    rescue => e
      puts "  ✗ Error loading ExpirePlansJob: #{e.message}"
    end

    # Summary
    puts "\n" + "=" * 70
    puts "END STATUS CHECK"
    puts "=" * 70 + "\n"
  end

  desc "Test run the ExpirePlansJob"
  task test_expire_plans: :environment do
    puts "\nTesting ExpirePlansJob..."
    puts "=" * 70
    begin
      ExpirePlansJob.new.perform
      puts "✓ Job executed successfully"
    rescue => e
      puts "✗ Job failed: #{e.message}"
      puts e.backtrace.first(5).join("\n")
    end
    puts "=" * 70 + "\n"
  end
end
