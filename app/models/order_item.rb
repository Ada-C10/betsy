class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def available_stock
    return [*1..self.product.inventory]
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



end
