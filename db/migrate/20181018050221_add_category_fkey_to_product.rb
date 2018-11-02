class AddCategoryFkeyToProduct < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :category
    add_reference :products, :category, foreign_key: true
  end
end
