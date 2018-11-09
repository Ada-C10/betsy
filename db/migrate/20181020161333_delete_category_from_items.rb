class DeleteCategoryFromItems < ActiveRecord::Migration[5.2]
  def change
    remove_column :items, :category
  end
end
