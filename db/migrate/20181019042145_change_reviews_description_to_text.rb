class ChangeReviewsDescriptionToText < ActiveRecord::Migration[5.2]
  def change
    change_column :reviews, :description, :text
  end
end
