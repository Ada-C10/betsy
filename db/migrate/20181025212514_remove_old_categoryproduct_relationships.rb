class RemoveOldCategoryproductRelationships < ActiveRecord::Migration[5.2]
  def change
    remove_index "category_id", name: "index_products_on_category_id"
  end
end
