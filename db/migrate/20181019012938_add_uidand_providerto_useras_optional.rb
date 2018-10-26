class AddUidandProvidertoUserasOptional < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :uid, :integer, optional: true
    add_column :users, :provider, :string, optional: true
  end
end
