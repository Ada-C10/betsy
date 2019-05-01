class CategoriesController < ApplicationController
  # skip_before_action :require_login, except: [:create, :update, :edit]
  # GET /category
  def index
    @categories = Category.all
  end

  # GET /category/1
  # def show
  # end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  # def edit
  # end

  # POST /categories
  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:success] = 'Category was successfully created.'
      redirect_to categories_path
    else
      flash.now[:warning] = 'Category not created'
      @category.errors.messages.each do |field, msg|
        flash.now[field] = msg
      end
      render :new
    end
  end

  private

  def category_params
    params.require(:category).permit(:category)
  end
end
