class ChangeReviewsColumn < ActiveRecord::Migration[5.2]
  def change
    add_reference :reviews, :user, foreign_key: true
    remove_column :reviews, :name
  end
end
