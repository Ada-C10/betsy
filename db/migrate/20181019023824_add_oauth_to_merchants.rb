class AddOauthToMerchants < ActiveRecord::Migration[5.2]
  def change
    add_column :merchants, :provider, :string, null: false
    add_column :merchants, :uid, :integer, null: false
  end
end
