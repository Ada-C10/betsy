class AddProviderToMerchants < ActiveRecord::Migration[5.2]
  def change
    add_column :merchants, :provider, :string, null: false
  end
end
