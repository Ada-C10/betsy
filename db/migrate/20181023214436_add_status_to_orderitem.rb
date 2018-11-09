class AddStatusToOrderitem < ActiveRecord::Migration[5.2]
  def change
    add_column :order_items, :status, :string, default: "pending"
  end
end
