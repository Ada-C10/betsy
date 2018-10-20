class Orderitem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_many :merchants, through: :products

  validates :quantity, presence: true, numericality: { only_integer: true }

end
