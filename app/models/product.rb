class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  belongs_to :merchant
  has_many :order_items

  validates :name, presence: true, uniqueness: true
<<<<<<< HEAD
  validates :price, presence: true, numericality: {greater_than: 0}
=======
  validates :price, presence: true, numericality: { greater_than: 0 }
>>>>>>> e3fedc4c6fe746c61ef171ef41ac749848949926
end
