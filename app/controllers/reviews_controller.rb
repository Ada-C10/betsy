class ReviewsController < ApplicationController
  skip_before_action :require_login

  def new
    @product = Product.find_by(id: params[:product_id])
    if @product
      @review = @product.reviews.new
    else
      render_404
    end
  end


  def create
    product = Product.find_by(id: params[:product_id])

    if @current_merchant == product.merchant
      flash[:error] = "You cannot submit a review for your own product: #{product.name}"

      redirect_to dashboard_path
      return
    else
      @review = product.reviews.new(review_params)
      if @review.save
        flash[:success] = "Successfully submitted review for: #{product.name}"
        redirect_to product_path(product)
      else
        flash[:error] = "Your review for product #{product.name} was not successfully submitted"
        # flash[:messages] = @review.errors.messages
        render :new, status: :bad_request
      end
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :product_id, :description)
  end
end
