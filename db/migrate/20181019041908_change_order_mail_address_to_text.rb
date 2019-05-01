class ChangeOrderMailAddressToText < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :mailing_address, :text
  end
end
