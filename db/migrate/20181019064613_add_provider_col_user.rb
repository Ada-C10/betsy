class AddProviderColUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :provider, :string
    change_column :users, :uid, :integer, null: false
    change_column :users, :username, :string, null: false

    # reset column info to prevent strange things
    User.reset_column_information

    # update vote count values in db
    User.all.each do |user|
      user.update_attribute :provider, 'github'
    end

  end
end
