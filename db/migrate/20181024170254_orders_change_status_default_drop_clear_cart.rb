class OrdersChangeStatusDefaultDropClearCart < ActiveRecord::Migration[5.2]
  def change
    change_column_default :orders, :payment_status, "pending"
    remove_column :orders, :clear_cart, :boolean
  end
end
