class AddProductIdToOrderItem < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :order_items, foreign_key: true
    add_reference :orders, :order_items, foreign_key: true
  end
end
