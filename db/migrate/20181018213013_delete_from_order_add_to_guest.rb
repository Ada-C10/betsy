class DeleteFromOrderAddToGuest < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :name
    remove_column :orders, :address
    remove_column :orders, :cc_num
    remove_column :orders, :exp_date
    remove_column :orders, :email
    remove_column :orders, :zip
    remove_column :orders, :cvv
    create_table :guests
    add_column :guests, :name, :string
    add_column :guests, :address, :string
    add_column :guests, :cc_num, :integer
    add_column :guests, :exp_date, :date
    add_column :guests, :zip, :string
    add_column :guests, :cvv, :string
    add_reference :orders, :guest, foreign_key: true


  end
end
