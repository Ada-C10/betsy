
class ReviewsController < ApplicationController
#
#
#   def new
#     @review = Review.new
#   end
#
#   def create
#
#     # session[:user_id] != @current_user ? can_review = true : can_review = false
#     # if can_review
#     @review = Review.new(
#       description: params[:review][:description],
#       rating:params[:review][:rating],
#       item_id: params[:item_id],
#       user_id: 3
#     )
#
#
#    @review.save
#
#       flash[:sucess] = "Thank you for your review!"
#       redirect_to items_path(@item)
#
#
#   end
#
#   def edit
#   end
#
#   def show
#     head :not_found unless @review
#   end
#
#   def update
#
#     success_save = @review.update(
#       description: params[:review][:description],
#       rating:params[:review][:rating],
#       item_id: params[:id],
#       user_id: session[:user_id]
#     )
#
#     if success_save
#       flash[:success] = "Review of #{@item.name} successfully reviewed."
#       redirect_to shop_path
#     else
#       flash.now[:error] =  "Error in reviewing product"
#       render :edit, status: 400
#     end
#   end
#
#   def filtered_params
#
#     return params.require(:review).permit(
#       :description,
#       :rating,
#       :item_id sessions[:item_id]
#       :user_id session[:user_id]
#     )
end
