class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.float :price
      t.string :category
      t.string :description
      t.integer :stock
      t.string :photo_url

      t.timestamps
    end
  end
end
