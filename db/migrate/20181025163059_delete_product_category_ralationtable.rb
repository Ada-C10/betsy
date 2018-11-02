class DeleteProductCategoryRalationtable < ActiveRecord::Migration[5.2]
  def change
    drop_table :products_categories
  end
end
