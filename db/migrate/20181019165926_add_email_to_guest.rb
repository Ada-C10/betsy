class AddEmailToGuest < ActiveRecord::Migration[5.2]
  def change
    add_column :guests, :email, :string
  end
end
