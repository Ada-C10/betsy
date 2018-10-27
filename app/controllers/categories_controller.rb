class CategoriesController < ApplicationController

  def new
    # puts params.to_h
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created new category: #{@category.name}"
      redirect_to categories_path(@category)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create #{@category.name}"
      flash[:messages] = @category.errors.messages
      render :new, status: :bad_request
    end
  end

  private
  def category_params
    params.require(:category).permit(:name)
  end
end
