class Providernil < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :provider, :string, null: true
  end
end
