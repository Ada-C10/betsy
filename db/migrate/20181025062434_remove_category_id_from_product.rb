class RemoveCategoryIdFromProduct < ActiveRecord::Migration[5.2]
  def change
    remove_reference :products, :category, foreign_key: true
  end
end
