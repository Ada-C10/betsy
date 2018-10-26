class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item
  validates :item_id, presence: true
  validates :order_id, presence: true

  def submit_order_item

    item = Item.find_by(id: self.item_id)
    if item
      item.decrement_quantity_available(self.quantity_per_item)
      #change order item status
      self.status = "paid"
      self.save
    end
  end

  def find_item_name(num)
    item = Item.find_by(id: num)
    if item
      item_name = item.name
      return item_name
    end
  end

  def find_order(num)
    order = Order.find_by(id: num)
    return order
  end

end
