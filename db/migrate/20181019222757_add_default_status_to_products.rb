class AddDefaultStatusToProducts < ActiveRecord::Migration[5.2]
  def change
    change_column :products, :status, :boolean, default: true
  end
end
