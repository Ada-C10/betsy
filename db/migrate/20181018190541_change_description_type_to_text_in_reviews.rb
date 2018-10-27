class ChangeDescriptionTypeToTextInReviews < ActiveRecord::Migration[5.2]
  def change
    remove_column :reviews, :description, :string
    add_column :reviews, :description, :text
  end
end
