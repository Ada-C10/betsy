class CategoriesController < ApplicationController
  before_action :find_category

  def show
  end

  def category_params
    return params.require(:category).permit(:name)
  end

  def find_category
    @category = Category.find_by(id: params[:id])
  end

end
