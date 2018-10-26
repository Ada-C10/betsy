class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :street
      t.string :city
      t.string :state
      t.integer :zip
      t.integer :creditcard
      t.date :ccexpiration
      t.integer :cvv
      t.integer :billingzip
      t.string :photo

      t.timestamps
    end
  end
end
