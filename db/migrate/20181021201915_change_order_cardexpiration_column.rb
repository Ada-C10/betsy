class ChangeOrderCardexpirationColumn < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :cc_expiration, :string
  end
end
