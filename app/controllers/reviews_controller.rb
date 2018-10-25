class ReviewsController < ApplicationController

  def create
    review = Review.new(review_params)
    product = Product.find_by(id: params[:id])
    review.product = product

    merchant_products = Product.all.where(merchant_id:@logged_in_merchant.id)

    product_ids = merchant_products.map { |p| p.id }


    if product_ids.include?(@logged_in_merchant.id)
      if review.save
        flash[:status] = :success
        flash[:result_text] = "Thanks for your review!"

        redirect_to product_path(product.id)
      else
        flash[:status] = :failure
        flash[:result_text] = "There was a problem saving your review"
        redirect_back fallback_location: root_path
      end
    else
      flash[:status] = :failure
      flash[:result_text] = "Cannot add a review for your own product!"
      redirect_back fallback_location: root_path
    end

  end

  private

  def review_params
    params.require(:review).permit(:rating, :description)
  end


end
