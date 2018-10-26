class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.integer :star_rating
      t.string :text

      t.timestamps
    end
  end
end
