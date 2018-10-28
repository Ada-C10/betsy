class CreateOrderproducts < ActiveRecord::Migration[5.2]
  def change
    create_table :orderproducts do |t|
      t.belongs_to :order, index: true
      t.belongs_to :product, index: true
      t.integer :quantity

      t.timestamps
    end
  end
end
