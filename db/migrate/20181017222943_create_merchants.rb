class CreateMerchants < ActiveRecord::Migration[5.2]
  def change
    create_table :merchants do |t|
      t.string :username
      t.string :email
      t.integer :uid
      t.string :provider
      t.timestamps
    end
  end
end
