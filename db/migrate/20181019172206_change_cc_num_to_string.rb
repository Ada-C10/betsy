class ChangeCcNumToString < ActiveRecord::Migration[5.2]
  def change
    remove_column :guests, :cc_num
    add_column :guests, :cc_num, :string
  end
end
