class Remvoing < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :uid
    remove_column :users, :provider
  end
end
