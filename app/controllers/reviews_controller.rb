require 'pry'
class ReviewsController < ApplicationController
  skip_before_action :require_login, only: [:create]
  def create
    @review = Review.new(review_params)
    if @review.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created your review!"
      redirect_to product_path(@review.product_id)
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not create your review."
      flash.now[:messages] = @review.errors.messages
      render :new, status: :bad_request
    end
  end

  private
  def review_params
    params.require(:review).permit(:name, :description, :product_id, :rating)
  end
end
