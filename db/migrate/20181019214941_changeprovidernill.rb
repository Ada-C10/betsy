class Changeprovidernill < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :provider, :string
  end
end
