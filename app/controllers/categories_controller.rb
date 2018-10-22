class CategoriesController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]
  # Need to be logged in to create a new category

  def index
    @categories = Category.all.order(:name)
  end

  def show
    id = params[:id].to_i
    @category = Category.find_by(id: id)
    @products = @category.products

    if @category.nil?
     render "layouts/notfound", status: :not_found
    end
  end

  def new
  end

  def create
  end
end
