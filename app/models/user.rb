class User < ApplicationRecord
  has_secure_password

  enum :role, { user: 0, admin: 1 }
  enum :plan, { free: 0, silver: 1, gold: 2 }, default: :free

  belongs_to :subscription_plan, class_name: "Plan", foreign_key: "plan_id", optional: true  
  has_many :orders, dependent: :destroy
  has_many :cart_items, dependent: :destroy

  before_create :set_default_role

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  def active_plan_name
    if subscription_plan.present? && plan_expires_at&.future?
      subscription_plan.name.downcase.to_sym 
    else
      :free
    end
  end

  def set_default_role
    self.role ||= :user
  end
end