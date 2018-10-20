class Orderitem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_many :merchants, through: :products

  validates :product_id, uniqueness: { scope: :order_id, message: "has already added this item to the cart"}

  validate :quantity_cannot_be_greater_than_product_inventory
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def quantity_cannot_be_greater_than_product_inventory
    if quantity > product.inventory
      errors.add(:quantity, "can't be greater than product inventory")
    end
  end
end
