class AddMerchantIdToProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :merchants, foreign_key: true
  end
end
