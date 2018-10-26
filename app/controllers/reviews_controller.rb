class ReviewsController < ApplicationController

  def create
    review = Review.new(review_params)
    review.product = Product.find_by(id: params[:id])
    if @logged_in_merchant
      merchant_products = Product.all.where(merchant_id:@logged_in_merchant.id)
      products = merchant_products.map { |p| p.id }
      if products && products.include?(review.product.id)
        flash[:status] = :failure
        flash[:result_text] = "Cannot add a review for your own product!"
        redirect_back fallback_location: root_path
      else
        if review.save
          flash[:status] = :success
          flash[:result_text] = "Thanks for your review!"

          redirect_back fallback_location: root_path
        else
          flash[:status] = :failure
          flash[:result_text] = "There was a problem saving your review"
          redirect_back fallback_location: root_path
        end
      end

    else
      if review.save
        flash[:status] = :success
        flash[:result_text] = "Thanks for your review!"

        redirect_back fallback_location: root_path
      else
        flash[:status] = :failure
        flash[:result_text] = "There was a problem saving your review"
        redirect_back fallback_location: root_path
      end

    end

  end

  private

  def review_params
    params.require(:review).permit(:rating, :description)
  end


end
