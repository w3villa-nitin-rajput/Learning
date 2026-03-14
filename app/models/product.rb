class Product < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  validates :name, presence: true
  validates :category, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :offer_price, numericality: { greater_than: 0 }, allow_nil: true

  scope :by_category, ->(cat) { where("LOWER(category) = ?", cat.downcase) if cat.present? }
  scope :in_stock_only, -> { where(in_stock: true) }
  scope :search_by_term, ->(term) {
    search_term = "%#{term}%"
    where("name ILIKE :search OR category ILIKE :search", search: search_term)
  }

 def price_for_user(user)
  return price unless user
  
  tier = user.active_plan_name # This will now return :gold, :silver, or :free
  
  case tier
  when :gold
    (price * 0.8).round(2)
  when :silver
    (price * 0.9).round(2)
  else
    price
  end
 end
end
