class RemoveFkeyFromReview < ActiveRecord::Migration[5.2]
  def change
    remove_reference :reviews, :user, foreign_key: true
    add_column :reviews, :reviewer, :string
  end
end
