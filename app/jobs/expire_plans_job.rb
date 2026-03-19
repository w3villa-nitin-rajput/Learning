class ExpirePlansJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "=== ExpirePlansJob started at #{Time.current} ==="

    begin
      # Find users whose plans have expired
      expired_users = User.where("plan != ? AND plan_expires_at IS NOT NULL AND plan_expires_at <= ?", User.plans[:free], Time.current)

      Rails.logger.info "Found #{expired_users.count} users with expired plans"

      expired_users.find_each do |user|
        old_plan = user.plan
        user.update(plan: :free, plan_expires_at: nil)
        Rails.logger.info "Updated user #{user.id} (#{user.email}): #{old_plan} -> free"
      end

      Rails.logger.info "=== ExpirePlansJob completed successfully ==="
    rescue => e
      Rails.logger.error "ExpirePlansJob failed: #{e.class} - #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      raise
    end
  end
end
