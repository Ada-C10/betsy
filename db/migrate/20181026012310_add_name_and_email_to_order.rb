class AddNameAndEmailToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :name, :string
    add_column :orders, :email, :string
  end
end
