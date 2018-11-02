class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :order, presence: true
  validates :product, presence: true
  validates :status, presence: true
  validates :status, inclusion: { in: %w(pending paid shipped cancelled),
    message: "%{value} is not a valid order status" }

  def subtotal
    return product.price * quantity
  end

  def submit_order
    if product.update_stock(quantity)
      self.status = "paid"
      return self.save
    else
      return false
    end
  end

  def edit_quantity(quantity_ordered)
    if quantity_ordered == 0
      return self.destroy
    elsif product.available?(quantity_ordered)
      return self.update(quantity: quantity_ordered)
    else
      return false
    end
  end
end
