class AddPlanToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :plan, :integer
    add_column :users, :plan_expires_at, :datetime
  end
end
