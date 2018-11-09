class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :category
      t.integer :price
      t.string :image
      t.integer :quantity_available
      t.string :name
      t.string :description
      t.integer :avg_rating

      t.timestamps
    end
  end
end
