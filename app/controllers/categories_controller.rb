class CategoriesController < ApplicationController
  before_action :find_category, only:[:show]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:success] = "Congratulations - you successfully entered a new category!"
      redirect_to category_path(@category.id)
    else
      flash.now[:error] = "The data you entered was not valid.  Please try again."
      render :new, status: :bad_request
    end
  end

  def show; end

  def find_category
    @category = Category.find_by(id: params[:id])
  end

  private

  def category_params
    return params.require(:category).permit(
      :name,
      product_ids: []
    )
  end

end
