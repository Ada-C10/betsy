class ChangeMoneyRelatedColumnsDataTypes < ActiveRecord::Migration[5.2]
  def change
    change_column :products, :price, :decimal, :precision => 8, :scale => 2
    change_column :orders, :total_cost, :decimal, :precision => 8, :scale => 2
  end
end
