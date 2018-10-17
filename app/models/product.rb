class Product < ApplicationRecord
  has_many :reviews
  belongs_to :merchant

  validates :name, presence: true, uniqueness: true
  validates :cost, presence: true, numericality: { greater_than: 0 }, allow_nil: true
  # validates :category, presence: true # let's think more about categories
  validates :inventory, presence: true, numericality: { only_integer: true }
  validates :description, presence: true
  validates :active, inclusion: { in: [true, false] }
  validates :image_url, presence: true
end
