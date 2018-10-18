class RemoveJoinTable < ActiveRecord::Migration[5.2]
  def change
    drop_join_table :merchants, :orders
  end
end
