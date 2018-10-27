class AddDescriptionColumnToProduct < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :description, :string
    add_column :products, :description, :text
  end
end
