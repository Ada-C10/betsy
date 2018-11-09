class AddQuantityToOrderitems < ActiveRecord::Migration[5.2]
  def change
    add_column :order_items, :quantity_per_item, :integer
  end
end
