class OrdersItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }


  def calculate_total
    return self.product.price * self.quantity
  end
end
