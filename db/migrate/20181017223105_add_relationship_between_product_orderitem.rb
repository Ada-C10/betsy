class AddRelationshipBetweenProductOrderitem < ActiveRecord::Migration[5.2]
  def change
    add_reference :orderitems, :product, foreign_key: true
  end
end
