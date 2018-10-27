class ChangeProductAndOrderStatus < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :status, :boolean, default: true
    change_column :orders, :status, :string, default: 'pending'
  end
end
