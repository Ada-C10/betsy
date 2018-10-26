class CategoriesController < ApplicationController

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:status] = :success
      flash[:result_text] = "Category #{@category.name} successfully created."
      redirect_to dashboard_path(session[:user_id])
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Invalid category name. Please try again."
      render :new, status: :bad_request
    end
  end

  private

  def category_params
    return params.require(:category).permit(
      :name
    )
  end

end
