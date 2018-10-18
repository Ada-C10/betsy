class RemoveRelationshipFromProduct < ActiveRecord::Migration[5.2]
  def change
    remove_reference :products, :category, index: true, foreign_key: true
  end
end
