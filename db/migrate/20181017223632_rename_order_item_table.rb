class RenameOrderItemTable < ActiveRecord::Migration[5.2]
  def change
    rename_table :order_items, :order_product
  end
end
