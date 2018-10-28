class CategoriesController < ApplicationController
before_action :find_category, only: [:show, :destroy]
before_action :require_login, only: [:new]


  def index
    @categories = Category.category_list
  end

  def show; end

  def new
    @category = Category.new
  end

  def create
    @products = Product.new
    @category = Category.new(category_params)

    if @category.save
      # redirect_to '/books'
      flash[:success] = "Category created successfully."
      redirect_to categories_path
    else
      # Validations failed! What do we do?
      # This flash message is redundant but for demonstration purposes
      flash.now[:danger] = "No category created."
      render :new, status: :bad_request
    end
  end

private
  def find_category
    @category = Category.find_by(id: params[:id])

    head :not_found unless @category
  end

  def category_params
    params.require(:category).permit(:name, product_ids: [])
  end

end
