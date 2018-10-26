class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :status
      t.string :name
      t.string :email
      t.string :address
      t.integer :cc_num
      t.integer :cc_cvv
      t.date :cc_expiration
      t.timestamps
    end
  end
end
