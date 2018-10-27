class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :email
      t.string :mailing_address
      t.integer :cc
      t.string :cc_name
      t.string :cc_expiration
      t.integer :cvv
      t.integer :zip

      t.timestamps
    end
  end
end
