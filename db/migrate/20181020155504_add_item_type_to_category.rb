class AddItemTypeToCategory < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :category_type, :string
  end
end
