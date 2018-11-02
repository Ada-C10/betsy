class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "Successfully created #{@category.name}!"

      redirect_to products_path
    else
      flash.now[:warning] = "Category is not created!"
      @category.errors.messages.each do |field, messages|
        flash.now[field] = messages
      end
      render :new, status: :bad_request
    end
  end

  private

    def category_params
      return params.require(:category).permit(:name)
    end
end
