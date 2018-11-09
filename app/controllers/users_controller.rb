class UsersController < ApplicationController
  #remove shop from below filter once conenct user_login
  before_action :find_searched_user, only: [:show]
  before_action :find_current_user_unfulfilled_items, only: [:shop]

  #user profile / merchant page that is visible to all
  def show
    head :not_found unless @user
    # render 'layouts/invalid_page', status: :not_found
  end

  #merchant view that is visible to just merchants
  def shop
    unless @current_user
      flash[:error] = "You need to sign up to create a shop."
      redirect_to root_path
      return
    end
  end

  def merchant_pending_orders
    # @testing = "Shoe"
    current_merchant = session[:user_id]
# raise
    items_sold_by_merchant = find_items_sold_by_merchant(current_merchant)
    item_ids = items_sold_by_merchant.map do |item|
      item.id
    end

    @pending_order_items = []
    item_ids.each do |x|
      order_items = OrderItem.where(item_id: x)

      order_items.each do |order_item|
        @pending_order_items << order_item
      end
    end

  end

  def paid
    order_item_id = params[:item_id]
    order_item = OrderItem.find_by(id: order_item_id)
    order_item.status = "shipped"
    order_item.save
    redirect_back(fallback_location: root_path)
  end

  private

  #strong params
  def user_params
    return params.require(:user).permit(
      :name,
      :nickname,
      :email,
      :image_url,
      :uid,
      :provider
    )
  end

  def find_searched_user
    @user = User.find_by(id: params[:id])
  end

  #helper method to find items this user sells
  def find_current_user_items
    if @current_user
      return @current_user.items
    end
  end

  def find_current_user_unfulfilled_items

  @current_user_items = find_current_user_items

  if @current_user_items.nil? || @current_user_items.empty?
    return
  end

    @current_merchant_unfulfilled_order_items = @current_user_items.map do |item|
      OrderItem.where(item_id: item.id) && OrderItem.where(status: "ordered")
    end
    @current_merchant_unfulfilled_order_items.flatten!
  end


  def find_items_sold_by_merchant(merchant_id)
    items = Item.where(user_id: merchant_id)
    return items
  end
end
