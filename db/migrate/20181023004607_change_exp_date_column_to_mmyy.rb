class ChangeExpDateColumnToMmyy < ActiveRecord::Migration[5.2]
  def change

    remove_column :orders, :exp_date
    add_column :orders, :exp_month, :integer
    add_column :orders, :exp_year, :integer

  end
end
