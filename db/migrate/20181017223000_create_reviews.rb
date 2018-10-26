class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.string :name
      t.integer :rating
      t.string :description
      t.belongs_to :product, index: true
      t.timestamps
    end
  end
end
