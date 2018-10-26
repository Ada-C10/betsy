class CategoriesController < ApplicationController
  before_action :require_login, only: [:new, :create]

  def index
    @categories = Category.all.order(:name)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:success] = "#{@category.name} added!"
      redirect_to dashboard_path(@current_user.id)
    else #save failed
      flash.now[:danger] = "Category #{@category.name} not added!"
      render :new, status: :bad_request
    end
  end

  def show
    @category = Category.find_by(id: params[:id])

    if @category.nil?
      flash.now[:danger] = "Cannot find the category #{params[:id]}"
      render :notfound, status: :not_found
    end
  end

  private

  def category_params
    return params.require(:category).permit(:name)
  end


end
