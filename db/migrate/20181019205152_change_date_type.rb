class ChangeDateType < ActiveRecord::Migration[5.2]
  def change
    remove_column :guests, :exp_date
    add_column :guests, :exp_date, :string
  end
end
