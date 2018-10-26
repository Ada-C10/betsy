class CreateOrdersItemsJoin < ActiveRecord::Migration[5.2]
  def change
    create_table :orders_items do |t|
      t.belongs_to :order, index: true, foreign_key: true
      t.belongs_to :product, index: true, foreign_key: true
    end
  end
end
