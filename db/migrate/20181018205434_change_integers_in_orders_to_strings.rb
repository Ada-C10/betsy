class ChangeIntegersInOrdersToStrings < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :cc, :string
    change_column :orders, :cvv, :string
    change_column :orders, :zip, :string
    change_column :orders, :cc_expiration, :string
  end
end
