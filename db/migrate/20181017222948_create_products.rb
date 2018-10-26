class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.string :photo
      t.integer :stock
      t.boolean :active
      t.string :category
      t.decimal :rating
      t.belongs_to :merchant, index: true
      t.timestamps
    end
  end
end
