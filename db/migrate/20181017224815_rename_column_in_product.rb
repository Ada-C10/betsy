class RenameColumnInProduct < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :status
    add_column :products, :active, :boolean, default: true
  end
end
