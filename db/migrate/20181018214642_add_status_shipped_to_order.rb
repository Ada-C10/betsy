class AddStatusShippedToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :status, :string, default: "pending"
    add_column :orders, :shipped, :boolean, default: false
  end
end
