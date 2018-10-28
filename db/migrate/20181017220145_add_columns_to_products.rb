class AddColumnsToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column(:products, :stock_count, :integer)
  end
end
