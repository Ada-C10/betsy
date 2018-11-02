class Order < ApplicationRecord
  belongs_to :user
  has_many :order_products, dependent: :destroy
  has_many :products, through: :order_products # might not need this, if so, update tests too

  accepts_nested_attributes_for :user, update_only: true

  validates :user, presence: true
  validates :status, presence: true
  validates :status, inclusion: { in: %w(pending paid shipped),
    message: "%{value} is not a valid order status" }

  def total
    return order_products.map { |op| op.valid? ? op.subtotal : 0 }.sum
  end

  def add_product(product, quantity_ordered)
    # check if product is already in cart
    current_op = order_products.find_by(product_id: product.id)

    if product.available?(quantity_ordered) && self.user != product.user
      if current_op
        current_op.edit_quantity(quantity_ordered)
      else
        current_op = self.order_products.create(product_id: product.id, quantity: quantity_ordered, order_id: self.id, status: "pending")
      end
      return current_op.save
    else
      return false
    end
  end

  def edit_quantity(op, quantity_ordered)
    return op.edit_quantity(quantity_ordered)
  end

  def submit_order
    if order_products.each { |op| op.submit_order }
      self.status = "paid"
      return self.save
    else
      return false
    end
  end
end
