class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer :uid
      t.string :username
      t.string :email

      t.timestamps
    end
  end
end
