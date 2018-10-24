class CategoryImageUrlDefault < ActiveRecord::Migration[5.2]

  def up
    change_column_default :categories, :image_url, "category-default.jpg"
    Category.where(image_url: nil).update_all(image_url: "category-default.jpg")
  end

  def down
    change_column_default :categories, :image_url, nil
  end
end
