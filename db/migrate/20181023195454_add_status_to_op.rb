class AddStatusToOp < ActiveRecord::Migration[5.2]
  def change
    add_column :order_products, :status, :string
  end
end
