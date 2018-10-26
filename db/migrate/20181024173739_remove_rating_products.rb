class RemoveRatingProducts < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :rating
  end
end
