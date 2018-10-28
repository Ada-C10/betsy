class AddMoreColumnsProducts < ActiveRecord::Migration[5.2]
  def change
    add_column(:products, :price, :integer)
    add_column(:products, :category, :string)
    add_column(:products, :photo_url, :string)
    add_column(:products, :description, :string)
    add_column(:products, :name, :string)
  end
end
