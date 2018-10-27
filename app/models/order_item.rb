class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  TAX_RATE = 0.101

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :cant_exceed_inventory

  def available_stock
    return self.product.inventory > 0 ? [*1..self.product.inventory] : [0]
  end

  def item_total
    return self.quantity * self.product.price
  end

  def product_name
    return self.product.name
  end

  def order_status
    return self.order.status
  end

  def cant_exceed_inventory
    if self.product && quantity && quantity > self.product.inventory
      errors.add(:quantity, "Cannot order #{quantity}. Only #{self.product.inventory} in stock.")
    end
  end

end
