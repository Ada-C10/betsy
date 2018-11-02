class AddCcInfoToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :cc_exp, :datetime
    add_column :users, :bill_zip, :integer
    add_column :users, :cc_csv, :integer
  end
end
