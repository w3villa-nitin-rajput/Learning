class Order < ApplicationRecord
  belongs_to :user

  enum :status, { pending: 0, confirmed: 1, shipped: 2, delivered: 3, cancelled: 4 }

  validates :items, presence: true
  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :shipping_address, presence: true
  validates :payment_method, presence: true
end
