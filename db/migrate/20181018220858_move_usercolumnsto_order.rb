class MoveUsercolumnstoOrder < ActiveRecord::Migration[5.2]
  def change
    #Removing the fields from user and adding them to the orders db and we are also adding the Oauth fields to User
     remove_column :users,:street
     remove_column :users,:city
     remove_column :users,:state
     remove_column :users,:zip
     remove_column :users,:creditcard
     remove_column :users,:ccexpiration
     remove_column :users,:cvv
     remove_column :users,:billingzip
     add_column :users, :uid, :integer, null: false
     add_column :users, :provider, :string, null: false

     #User info is stored to an order
     add_column :orders, :street, :string
     add_column :orders, :city, :string
     add_column :orders, :state, :string
     add_column :orders, :zip, :integer
     add_column :orders, :creditcard, :integer
     add_column :orders, :ccexpiration, :date
     add_column :orders, :cvv, :integer
     add_column :orders, :billingzip, :integer
  end
end
