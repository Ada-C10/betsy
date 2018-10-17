class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :status
      t.string :name
      t.string :address
      t.integer :cc_num
      t.date :exp_date
      t.string :email
      t.string :zip
      t.string :cvv

      t.timestamps
    end
  end
end
