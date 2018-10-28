class AddRelationshipToProduct < ActiveRecord::Migration[5.2]
  def change
    add_index :products, :category_id
  end
end
