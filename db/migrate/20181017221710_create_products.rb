class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.float :cost
      t.string :category
      t.string :image_url
      t.integer :inventory
      t.string :description
      t.boolean :status

      t.timestamps
    end
  end
end
