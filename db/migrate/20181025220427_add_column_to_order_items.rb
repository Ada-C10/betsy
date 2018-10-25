class AddColumnToOrderItems < ActiveRecord::Migration[5.2]
  def change
    add_column :order_items, :status, :boolean, default: false
  end
end
