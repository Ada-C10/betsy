class AddDefaultImage < ActiveRecord::Migration[5.2]
  def change
      change_column_default :products, :photo_url, "https://i.imgur.com/lbztpnF.jpg"
  end
end
