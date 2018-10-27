class AddInventoryColumnToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :inventory, :integer 
  end
end
