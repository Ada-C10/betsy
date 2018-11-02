class RenameOrderProduct < ActiveRecord::Migration[5.2]
  def change
    rename_table :order_product, :order_products
  end
end
