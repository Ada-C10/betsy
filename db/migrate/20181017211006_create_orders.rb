class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :name
      t.string :email
      t.string :mailing_address
      t.integer :zip_code
      t.integer :cc_number
      t.integer :cc_expiration
      t.integer :cc_cvv
      t.string :status
      t.integer :total_cost

      t.timestamps
    end
  end
end
