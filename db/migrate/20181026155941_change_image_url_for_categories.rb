class ChangeImageUrlForCategories < ActiveRecord::Migration[5.2]
  def change
    change_column_default :categories, :image_url, "https://s3.amazonaws.com/ada-student-project-noregretsy/category-default.jpg"
    Category.where(image_url: nil).update_all(image_url: "https://s3.amazonaws.com/ada-student-project-noregretsy/category-default.jpg")
  end
end
