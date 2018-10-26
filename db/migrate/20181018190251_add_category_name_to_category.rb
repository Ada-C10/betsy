class AddCategoryNameToCategory < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :category_name, :string
  end
end
