class CreateColumnsForUserTable < ActiveRecord::Migration[5.2]
  def change
    create_table :columns_for_user_tables do |t|
      add_column :users, :name, :string
      add_column :users, :address, :string
      add_column :users, :cc_num, :string
      add_column :users, :type, :string
    end
  end
end
