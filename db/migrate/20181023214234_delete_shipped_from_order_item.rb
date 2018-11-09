class DeleteShippedFromOrderItem < ActiveRecord::Migration[5.2]
  def change
    remove_column :order_items, :shipped
  end
end
