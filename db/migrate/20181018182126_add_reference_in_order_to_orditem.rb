class AddReferenceInOrderToOrditem < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :order_item, foreign_key: true
  end
end
