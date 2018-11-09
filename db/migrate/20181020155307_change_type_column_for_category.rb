class ChangeTypeColumnForCategory < ActiveRecord::Migration[5.2]
  def change
    remove_column :categories, :type
  end
end
