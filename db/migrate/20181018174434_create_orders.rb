class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :payment_status
      t.boolean :clear_cart
      t.integer :total_price
      t.datetime :date_time_placed
      t.string :fulfillment_status
      t.string :guest_user_info

      t.timestamps
    end
  end
end
