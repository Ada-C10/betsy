class ReviewsController < ApplicationController

  def create
    @product = Product.find_by(id: params[:id])
    @review = Review.new(review_params)
    @review.product = @product

    if @review.save
      flash[:status] = :success
      flash[:result_text] = "Review added to product"

      redirect_to product_path(@product.id)
    else
      flash[:status] = :failure
      flash[:result_text] = "There was a problem saving your review"
      redirect_back fallback_location: root_path
    end

  end

  private

  def review_params
    return params.require(:review).permit(
      :rating,
      :description,
    )
  end


end
