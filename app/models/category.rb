class Category < ApplicationRecord
  validates :name, presence: true
  validates :path, presence: true, uniqueness: true
  validates :bg_color, presence: true
end
