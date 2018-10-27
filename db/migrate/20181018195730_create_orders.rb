class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :email
      t.string :address
      t.integer :cc_num
      t.datetime :order_placed
      t.string :status
      t.integer :zip
      t.string :name
      t.integer :cvv
      t.datetime :exp_date

      t.timestamps
    end
  end
end
