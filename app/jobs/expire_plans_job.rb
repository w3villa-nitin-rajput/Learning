class ExpirePlansJob < ApplicationJob
  queue_as :default

  def perform
    puts "[ExpirePlansJob] Starting at #{Time.current}"
    Rails.logger.info "[ExpirePlansJob] Starting at #{Time.current}"

    begin
      # Find users whose plans have expired
      expired_users = User.where("plan != ? AND plan_expires_at IS NOT NULL AND plan_expires_at <= ?", User.plans[:free], Time.current)

      count = expired_users.count
      puts "[ExpirePlansJob] Found #{count} users with expired plans"
      Rails.logger.info "[ExpirePlansJob] Found #{count} users with expired plans"

      expired_users.find_each do |user|
        old_plan = user.plan
        user.update(plan: :free, plan_expires_at: nil)
        puts "[ExpirePlansJob] Updated user #{user.id} (#{user.email}): #{old_plan} -> free"
        Rails.logger.info "[ExpirePlansJob] Updated user #{user.id} (#{user.email}): #{old_plan} -> free"
      end

      puts "[ExpirePlansJob] Completed successfully at #{Time.current}"
      Rails.logger.info "[ExpirePlansJob] Completed successfully at #{Time.current}"
    rescue => e
      puts "[ExpirePlansJob] FAILED: #{e.class} - #{e.message}"
      puts e.backtrace.first(10).join("\n")
      Rails.logger.error "[ExpirePlansJob] FAILED: #{e.class} - #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      raise
    end
  end
end
