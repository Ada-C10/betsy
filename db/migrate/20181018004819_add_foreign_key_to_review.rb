class AddForeignKeyToReview < ActiveRecord::Migration[5.2]
  def change
      add_reference :reviews, :products, foreign_key: true
  end
end
