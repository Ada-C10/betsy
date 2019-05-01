class ChangeCcDigitIntToBigint < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :cc_digit, :bigint
  end
end
