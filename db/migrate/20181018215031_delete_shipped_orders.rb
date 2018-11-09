class DeleteShippedOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :shipped
  end
end
