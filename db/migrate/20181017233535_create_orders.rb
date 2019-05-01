class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :status
      t.string :cust_name
      t.string :cust_email
      t.integer :mailing_address
      t.string :cc_name
      t.integer :cc_digit
      t.date :cc_expiration
      t.integer :cc_cvv
      t.integer :cc_zip

      t.timestamps
    end
  end
end
