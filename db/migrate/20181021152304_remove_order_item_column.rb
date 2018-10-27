class RemoveOrderItemColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :order_item_id
  end
end
