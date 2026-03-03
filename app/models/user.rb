class User < ApplicationRecord
  has_secure_password

  enum :role, { user: 0, admin: 1 }

  before_create :set_default_role

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  def set_default_role
    self.role ||= :user
  end
end