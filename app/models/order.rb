class Order < ApplicationRecord
  has_many :order_items

  TAX_RATE = 0.101

  def subtotal
    return self.order_items.sum { |o_items| o_items.item_total }
  end

  def self.tax_rate
    return (TAX_RATE * 100).round(2)
  end

  def total
    return self.subtotal * (1 + TAX_RATE)
  end


end
