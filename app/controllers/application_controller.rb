class ApplicationController < ActionController::Base
  before_action :current_order
  before_action :find_merchant
  before_action :find_user

  private

  def find_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_login
    # Check if current user is logged in (has uid/provider) # Would have user_id and provider and uid
    if !find_merchant
      flash[:danger] = "You must be logged in to view this section"
      redirect_to root_path
    end
  end

  def find_merchant
    @merchant = User.find_by(id: session[:user_id], provider: 'github')
    # What if it's nil?
  end

  def find_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_order
    # If nil, make one # Else, find and use the current one #Try and find the order
    #To avoid getting a complete shopping cart add the complete
    #at current order status will complete and it will create a new one
    @current_order = Order.find_by(id: session[:order_id], status: "pending")
    #if the @current_order object is nil it will return true
    if @current_order.nil? #
      #create @current_order if @current_order is nil
      @current_order = Order.create(status: "pending")
      session[:order_id] = @current_order.id
    # else #needs to move above the create nil
    #   #write a test to show the weakness of a project
    #   return @current_order
    #
    #what happens if find_by returns nil because it can?
    end
    return @current_order
  end

#   def current_order
#     @order = Order.find_by(id:session[:order_id])
#     return @order if @order
#     if the order has a merchant (use helper method?)
#       @order = Order.find_by(user_id: @merchant.id, status: "pending")#to find pending orders for a merchant
#       session[:order_id] = @order.id
#     else #They are checking out as a guest, there won't be a user_id relation
#       @order = Order.create(status: "pending")
#       session[:order_id] = @order.id
#     end
# #call set order are a merchant, find pending = nil. never going to next else to create one
#     return @order
# #hint this method should have at least one case where we are seeing if session id is already set -
# #this will avoid assigning a new cart to somebody who has one
#   end
end
