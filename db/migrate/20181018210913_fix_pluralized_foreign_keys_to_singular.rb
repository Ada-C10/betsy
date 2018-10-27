class FixPluralizedForeignKeysToSingular < ActiveRecord::Migration[5.2]
  def change
    remove_reference :order_items, :products, foreign_key: true
    remove_reference :order_items, :orders, foreign_key: true

    add_reference :order_items, :product, foreign_key: true
    add_reference :order_items, :order, foreign_key: true

  end
end
