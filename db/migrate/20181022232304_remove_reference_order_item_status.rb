class RemoveReferenceOrderItemStatus < ActiveRecord::Migration[5.2]
  def change
    remove_reference(:order_items, :order_status, index: true)

  end
end
