class ChangeIntLimit < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :cc_number, :integer, limit: 8
  end
end
