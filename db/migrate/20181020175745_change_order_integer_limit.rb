class ChangeOrderIntegerLimit < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :cc_num, :integer, :limit => 8
  end
end
