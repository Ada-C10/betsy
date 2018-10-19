class RemoveGuestModel < ActiveRecord::Migration[5.2]
  def change
    remove_column :guests, :name
    remove_column :guests, :address
    remove_column :guests, :cc_num
    remove_column :guests, :exp_date
    remove_column :guests, :email
    remove_column :guests, :zip
    remove_column :guests, :cvv
    add_column :orders, :name, :string
    add_column :orders, :address, :string
    add_column :orders, :cc_num, :string
    add_column :orders, :exp_date, :string
    add_column :orders, :zip, :string
    add_column :orders, :cvv, :string
    remove_reference :orders, :guest, index: true, foreign_key: true
  end
end
