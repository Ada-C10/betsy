class AddForeignKeyAssociations < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :user, foreign_key: true
    add_reference :reviews, :product, foreign_key: true
  end
end
