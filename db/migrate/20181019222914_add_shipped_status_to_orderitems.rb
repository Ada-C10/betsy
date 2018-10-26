class AddShippedStatusToOrderitems < ActiveRecord::Migration[5.2]
  def change
    add_column :order_items, :shipped, :boolean, default: false
  end
end
