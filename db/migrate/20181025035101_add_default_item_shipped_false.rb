class AddDefaultItemShippedFalse < ActiveRecord::Migration[5.2]
  def change
    change_column_default :order_items, :shipped, false
  end
end
