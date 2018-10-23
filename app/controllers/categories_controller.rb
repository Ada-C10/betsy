class CategoriesController < ApplicationController
  skip_before_action :require_login

  def index
    @categories = Category.all.order(:name)
  end

  def show
    @category = Category.find_by(id: params[:id].to_i)

    if @category.nil?
     render "layouts/notfound", status: :not_found
    else
     @products = @category.products
    end
  end
end
