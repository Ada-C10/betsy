class ProductsCategoriesJoin < ActiveRecord::Migration[5.2]
  def change
    create_table :products_categories do |t|
    t.belongs_to :product, index: true
    t.belongs_to :category, index: true
    end
  end
end
