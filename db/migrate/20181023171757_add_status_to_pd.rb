class AddStatusToPd < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :status, :boolean, default: true
  end
end
