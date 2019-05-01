class AddReferencesProductsOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column :order_items, :product_id
    remove_column :order_items, :order_id
    add_reference :order_items, :product, foreign_key: true
    add_reference :order_items, :order, foreign_key: true
  end
end
