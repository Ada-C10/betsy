require 'pry'
class Orderitem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_one :merchant, through: :product

  validates :product_id, uniqueness: { scope: :order_id, message: "has already added this item to the cart"}

  validate :quantity_cannot_be_greater_than_product_inventory
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def quantity_cannot_be_greater_than_product_inventory
    if quantity > product.inventory
      errors.add(:quantity, "can't be greater than product inventory")
    end
  end

  def line_item_price
    product = Product.find_by(id: self.product_id)
    return self.quantity * product.cost
  end

  def self.already_in_cart?(orderitem, order)
    record = self.all.where(product_id: orderitem.product_id, order_id: order.id)

    if record.empty?
      return false
    else
      return true
    end
  end
end
