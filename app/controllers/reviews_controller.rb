class ReviewsController < ApplicationController
  skip_before_action :require_login

  def create
    @review = Review.new(review_params)
    if @review.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created your review!"
      redirect_to product_path(@review.product_id)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create your review."
      flash[:messages] = @review.errors.messages
      redirect_back(fallback_location: root_path)
    end
  end

  private
  def review_params
    params.require(:review).permit(:name, :description, :product_id, :rating)
  end
end
