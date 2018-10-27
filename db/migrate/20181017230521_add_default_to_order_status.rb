class AddDefaultToOrderStatus < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :status
    add_column :orders, :status, :string, default: "pending"
  end
end
