class ReviewsController < ApplicationController
  before_action :cant_leave_review_for_own_product, only: [:new, :create]

  def new
    @review = Review.new
    @product = Product.find_by(id: params[:product_id])
  end

  def create
    @review = Review.new(review_params)
    @review.save
    redirect_to product_path(@review.product_id)
  end

  private
  def review_params
    params.require(:review).permit(:name, :rating, :review, :product_id)
  end

  def cant_leave_review_for_own_product
    user = Product.find_by(id: params[:product_id]).user
    if @current_user == user
      flash[:warning] = "You cannot review your own products!"
      redirect_to product_path(params[:product_id])
    end
  end

end
