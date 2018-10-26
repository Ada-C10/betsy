class CategoriesController < ApplicationController

  before_action :require_login, only: [:new, :create]

  def index
    @categories = Category.all
  end

  def new
    if @login_user.nil?
      render_404
    else
      @category = Category.new
    end
  end

  def create
    if @login_user.nil?
      flash[:status] = :failure
      flash[:result_text] = "You must be logged in to add a new category."
      redirect_to root_path
    else
      @category = Category.new(category_params)
      if @category.save
        flash[:status] = :success
        flash[:result_text] = "Successfully created category:
        #{@category.category_name}."
        redirect_to root_path
      else
        flash[:status] = :failure
        flash[:result_text] = "Could not create category: #{@category.category_name}."
        flash[:messages] = @category.errors.messages
        render :new, status: :bad_request
      end
    end
  end

  private

  def category_params
    params.require(:category).permit(:category_name)
  end
end
