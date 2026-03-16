class ExpirePlansJob < ApplicationJob
  queue_as :default

  def perform
    # Find users whose plans have expired
    Rails.logger.info "CRON CHECK: ExpirePlansJob is running at #{Time.now}"
    expired_users = User.where("plan != ? AND plan_expires_at <= ?", User.plans[:free], Time.current)
    
    expired_users.find_each do |user|
      user.update(plan: :free, plan_expires_at: nil)
    end
  end
end
