class AddReferenceOrderStatusToOrderItems < ActiveRecord::Migration[5.2]
  def change
    add_reference :order_items, :order_status, foreign_key: true
  end
end
