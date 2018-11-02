class RemoveExtraTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :columns_for_user_tables
  end
end
