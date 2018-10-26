class AddCategoryProductIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :categories_products, [:category_id, :product_id], unique: true
  end
end
