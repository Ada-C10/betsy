class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  has_one :merchant, through: :product

  validates_associated :product, :order, :merchant
  validates :quantity, presence: true, :numericality => { only_integer: true, greater_than_or_equal_to: 1 }
  validates :status, presence: true

end
