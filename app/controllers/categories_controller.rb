class CategoriesController < ApplicationController
  def index
    @categories = Category.all.order(:name)
  end

  def show
    @category = Category.find_by(id: params[:id])
    @products = @category.products
  end

  def create
  end

  def new
  end
end
