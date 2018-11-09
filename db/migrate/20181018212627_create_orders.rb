class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :name
      t.string :email
      t.string :mailing_address
      t.string :name_on_card
      t.integer :credit_card_num
      t.integer :credit_card_exp_month
      t.integer :credit_card_exp_year
      t.integer :cvv_num
      t.integer :zipcode


      t.timestamps
    end
  end
end
