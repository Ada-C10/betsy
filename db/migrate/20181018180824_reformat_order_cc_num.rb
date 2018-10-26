class ReformatOrderCcNum < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :cc_num, :bigint
  end
end
