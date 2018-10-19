class CategoriesController < ApplicationController
  before_action :find_category, only:[:show]

  def new
    @category = Category.new 
  end

  def show; end

  def category_params
    return params.require(:category).permit(:name)
  end

  def find_category
    @category = Category.find_by(id: params[:id])
  end

end
