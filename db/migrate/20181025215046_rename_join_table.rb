class RenameJoinTable < ActiveRecord::Migration[5.2]
  def change
    rename_table :products_categories, :categories_products
  end
end
