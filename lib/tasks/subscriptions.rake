namespace :subscriptions do
  desc "Expire user subscriptions that have passed their expiration date"
  task expire_plans: :environment do
    ExpirePlansJob.perform_now
  end
end
