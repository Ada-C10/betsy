class CategoryController < ApplicationController
  def show
    category_id = params[:id]
    @category = Category.find_by(id: category_id)
    @items_in_category = Item.where(active: true, category_id: category_id)

  end
end
