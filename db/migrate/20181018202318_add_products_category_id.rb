class AddProductsCategoryId < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :category_id, :integer
  end
end
