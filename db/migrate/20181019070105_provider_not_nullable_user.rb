class ProviderNotNullableUser < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :provider, :string, null: false
  end
end
