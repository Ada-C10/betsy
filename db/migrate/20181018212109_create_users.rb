class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer :uid
      t.string :name
      t.string :nickname
      t.string :email
      t.string :image_url
      t.string :provider

      t.timestamps
    end
  end
end
