class DeleteBadFkeysForOrderItemsReplaceWithOrderProductId < ActiveRecord::Migration[5.2]
  def change
    remove_reference :products, :order_items, foreign_key: true
    remove_reference :orders, :order_items, foreign_key: true

    add_reference :order_items, :products, foreign_key: true
    add_reference :order_items, :orders, foreign_key: true
  end
end
