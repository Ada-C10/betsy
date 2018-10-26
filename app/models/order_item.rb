class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0, only_integer: true }


  # TODO: change from true/false to pending etc. [this will cause errors i think until we can coordinate it]
  validates :shipped, inclusion: { in: [true, false] }

  def order_item_subtotal()
    price = convert_int_to_f(self.product.price)
    quantity = self.quantity

    return price * quantity
  end

  def decrement_inventory_via_order_item()
    product = self.product
    inventory = product.inventory

    quantity = self.quantity

    difference = inventory - quantity

    if  difference < 0
      raise ArguementError, "Guest cannot purchase more inventory than is available"
      # QUESTION: add flash messages? rescue?
    end

    product[:inventory] = difference
    result = product.save

    if result
      p "great"
      # QUESTION: add flash messages?
    else
      raise ArguementError, "Unable to alter product inventory"
      # QUESTION: add flash messages? rescue?
    end

  end
  def double_check_availability()
    if self.product.inventory < 1
      flash[:status] = :failure
      flash[:result_text] = "Sorry - product #{self.product.name} is no longer available!"

      redirect_to order_item_path(order_item.id), method: :delete
    end
  end



end
