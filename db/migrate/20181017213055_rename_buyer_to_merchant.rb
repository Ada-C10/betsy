class RenameBuyerToMerchant < ActiveRecord::Migration[5.2]
  def change
    rename_table :buyers, :merchants
  end
end
