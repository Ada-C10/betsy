class FixCategoryColumnInProduct < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :category
    
  end
end
