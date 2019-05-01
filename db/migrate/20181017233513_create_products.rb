class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :category
      t.string :prod_name
      t.string :description
      t.float :price
      t.integer :inv_qty

      t.timestamps
    end
  end
end
