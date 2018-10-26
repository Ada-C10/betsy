class OrderItem < ApplicationRecord
  STATUS = %w(pending paid complete cancelled)
  belongs_to :product
  belongs_to :order

  validates :quantity, presence: true, numericality: { greater_than: 0 }

  validates :status,  presence: true,
  inclusion: { in: STATUS }

  def price
    return self.product.price * self.quantity
  end

  def restock_product
    product = Product.find_by(id: self.product)
    new_stock = product.stock + self.quantity
    product.update(stock: new_stock)
    return new_stock
  end

  def reduce_stock(duplicate = self)
    remaining_stock = duplicate.product.stock - self.quantity
    return duplicate.product.update(stock: remaining_stock)
  end

end
