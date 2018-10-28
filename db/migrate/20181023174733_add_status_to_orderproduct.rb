class AddStatusToOrderproduct < ActiveRecord::Migration[5.2]
  def change
    add_column :orderproducts, :status, :string
  end
end
