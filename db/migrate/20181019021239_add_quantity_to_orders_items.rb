class AddQuantityToOrdersItems < ActiveRecord::Migration[5.2]
  def change
    add_column :orders_items, :quantity, :integer
  end
end
