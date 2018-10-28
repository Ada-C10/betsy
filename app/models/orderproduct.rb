class Orderproduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  STATUSES= %w(pending shipped)
  validates :status,  presence: true, inclusion: { in: STATUSES }
  validate :quantity_in_stock?, on: :create
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :product_id,  presence: true
  validates :order_id,  presence: true


  def self.create_product_orders(order_id, session)
    session.each do |item|
      item.each do |key, value|
        if value <= Product.find_by(id: key.to_i).stock_count
          Orderproduct.create(product_id: key.to_i, quantity: value, order_id: order_id, status: "pending")
        end
      end
    end
  end

  private

  def quantity_in_stock?
    if self.product && self.quantity
      if self.quantity > self.product.stock_count
        errors.add(:quantity, "Quantity must be available.")
      end
    end
  end

end
