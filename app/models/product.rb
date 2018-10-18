class Product < ApplicationRecord
  has_many :reviews
  has_and_belongs_to_many :categories
  belongs_to :merchant

  validates :name, presence: true, uniqueness: true
  validates :cost, presence: true, numericality: { greater_than: 0 }, allow_nil: true
  validates :inventory, presence: true, numericality: { only_integer: true }
  validates :description, presence: true
  validates :active, inclusion: { in: [true, false] }
  validates :image_url, presence: true
end
